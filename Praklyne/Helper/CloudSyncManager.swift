import Foundation
import FirebaseAuth
import FirebaseFirestore
import CoreData

class CloudSyncManager {
    static let shared = CloudSyncManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    private var currentUID: String? {
        Auth.auth().currentUser?.uid
    }
    
    // MARK: - 1. Sync Course Progress to Firestore
    func syncCourseProgress(
        totalDaysCompleted: Int,
        currentStreak: Int,
        totalHoursSpent: Double,
        lastWatchedDate: Date?,
        weeklyProgress: [[Bool]]
    ) {
        guard let uid = currentUID else { return }
        
        let week2Data = UserDefaults.standard.data(forKey: "week2Reflections")
        let week2Reflections = (try? JSONDecoder().decode([String: String].self, from: week2Data ?? Data())) ?? [:]
        
        let week3Data = UserDefaults.standard.data(forKey: "week3Writings")
        let week3Writings = (try? JSONDecoder().decode([String: String].self, from: week3Data ?? Data())) ?? [:]
        
        let flattenedWeekly = weeklyProgress.flatMap { $0 }
        
        let data: [String: Any] = [
            "totalDaysCompleted": totalDaysCompleted,
            "currentStreak": currentStreak,
            "totalHoursSpent": totalHoursSpent,
            "lastWatchedDate": lastWatchedDate != nil ? Timestamp(date: lastWatchedDate!) : NSNull(),
            "weeklyProgressFlattened": flattenedWeekly,
            "currentWeek": min(totalDaysCompleted / 7, 3) + 1,
            "week2Reflections": week2Reflections,
            "week3Writings": week3Writings,
            "lastUpdated": FieldValue.serverTimestamp()
        ]
        
        db.collection("users")
            .document(uid)
            .collection("progress")
            .document("course_progress")
            .setData(data, merge: true) { error in
                if let error = error {
                    print("❌ Error syncing course progress: \(error.localizedDescription)")
                } else {
                    print("☁️ Course progress synced to Firestore for user \(uid)")
                }
            }
    }
    
    // MARK: - 2. Sync Personal Vocabulary Word to Firestore
    func syncVocabularyWord(_ word: VocabularyWord) {
        guard let uid = currentUID else { return }
        
        let wordData: [String: Any] = [
            "id": word.id.uuidString,
            "english": word.english,
            "sinhala": word.sinhala,
            "category": word.category,
            "difficulty": word.difficulty,
            "isLearned": word.isLearned,
            "isFavorite": word.isFavorite,
            "addedDate": FieldValue.serverTimestamp()
        ]
        
        db.collection("users")
            .document(uid)
            .collection("vocabulary")
            .document(word.id.uuidString)
            .setData(wordData, merge: true) { error in
                if let error = error {
                    print("❌ Error syncing vocabulary word: \(error.localizedDescription)")
                } else {
                    print("☁️ Vocabulary word '\(word.english)' synced to Firestore")
                }
            }
    }
    
    // MARK: - Delete Personal Vocabulary Word from Firestore
    func deleteVocabularyWord(english: String, sinhala: String) {
        guard let uid = currentUID else { return }
        
        let col = db.collection("users").document(uid).collection("vocabulary")
        col.whereField("english", isEqualTo: english)
           .whereField("sinhala", isEqualTo: sinhala)
           .getDocuments { snap, error in
               if let snap = snap {
                   for doc in snap.documents {
                       doc.reference.delete()
                   }
               }
           }
    }
    
    // MARK: - 3. Restore User Data on Login (Re-install / Login)
    func restoreUserData(completion: @escaping () -> Void) {
        guard let uid = currentUID else {
            completion()
            return
        }
        
        // Restore Course Progress
        db.collection("users")
            .document(uid)
            .collection("progress")
            .document("course_progress")
            .getDocument { snap, error in
                if let data = snap?.data() {
                    if let days = data["totalDaysCompleted"] as? Int {
                        UserDefaults.standard.set(days, forKey: "totalDaysCompleted")
                    }
                    if let streak = data["currentStreak"] as? Int {
                        UserDefaults.standard.set(streak, forKey: "currentStreak")
                    }
                    if let hours = data["totalHoursSpent"] as? Double {
                        UserDefaults.standard.set(hours, forKey: "totalHoursSpent")
                    }
                    if let ts = data["lastWatchedDate"] as? Timestamp {
                        if let dateData = try? JSONEncoder().encode(ts.dateValue()) {
                            UserDefaults.standard.set(dateData, forKey: "lastWatchedDate")
                        }
                    }
                    if let flat = data["weeklyProgressFlattened"] as? [Bool], flat.count == 28 {
                        var matrix = Array(repeating: Array(repeating: false, count: 7), count: 4)
                        for i in 0..<28 {
                            matrix[i / 7][i % 7] = flat[i]
                        }
                        if let weekData = try? JSONEncoder().encode(matrix) {
                            UserDefaults.standard.set(weekData, forKey: "weeklyProgress")
                        }
                    }
                    if let w2 = data["week2Reflections"] as? [String: String],
                       let w2Data = try? JSONEncoder().encode(w2) {
                        UserDefaults.standard.set(w2Data, forKey: "week2Reflections")
                    }
                    if let w3 = data["week3Writings"] as? [String: String],
                       let w3Data = try? JSONEncoder().encode(w3) {
                        UserDefaults.standard.set(w3Data, forKey: "week3Writings")
                    }
                    print("✅ Restored course progress from Firestore for user \(uid)")
                }
                
                // Restore Personal Vocabulary to CoreData
                self.restoreVocabularyFromFirestore(uid: uid) {
                    completion()
                }
            }
    }
    
    private func restoreVocabularyFromFirestore(uid: String, completion: @escaping () -> Void) {
        db.collection("users")
            .document(uid)
            .collection("vocabulary")
            .getDocuments { snap, error in
                guard let snap = snap else {
                    completion()
                    return
                }
                
                let context = VocabularyPersistenceController.shared.container.viewContext
                context.perform {
                    // Fetch existing to avoid duplicates
                    let fetchRequest: NSFetchRequest<VocabularyItem> = VocabularyItem.fetchRequest()
                    let existingItems = (try? context.fetch(fetchRequest)) ?? []
                    let existingSet = Set(existingItems.map { "\($0.english ?? "")_\($0.sinhala ?? "")" })
                    
                    for doc in snap.documents {
                        let data = doc.data()
                        let eng = data["english"] as? String ?? ""
                        let sin = data["sinhala"] as? String ?? ""
                        let key = "\(eng)_\(sin)"
                        
                        if !existingSet.contains(key) && !eng.isEmpty {
                            let newItem = VocabularyItem(context: context)
                            newItem.id = UUID(uuidString: doc.documentID) ?? UUID()
                            newItem.english = eng
                            newItem.sinhala = sin
                            newItem.category = data["category"] as? String ?? "General"
                            newItem.difficulty = Int16(data["difficulty"] as? Int ?? 3)
                            newItem.isLearned = data["isLearned"] as? Bool ?? false
                            newItem.isFavorite = data["isFavorite"] as? Bool ?? false
                        }
                    }
                    try? context.save()
                    print("✅ Restored \(snap.documents.count) personal vocabulary words from Firestore")
                    completion()
                }
            }
    }
}

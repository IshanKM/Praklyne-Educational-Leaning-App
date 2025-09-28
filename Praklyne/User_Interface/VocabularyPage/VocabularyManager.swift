import Foundation
import CoreData

struct VocabularyManager {
    static let shared = VocabularyManager()
    private init() {}
    
   
    func getWordsForToday(limit: Int, context: NSManagedObjectContext) -> [VocabularyWord] {
       
        let lastIndex = UserDefaults.standard.integer(forKey: "lastVocabularyIndex")
        
       
        let request: NSFetchRequest<VocabularyItem> = VocabularyItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \VocabularyItem.english, ascending: true)]
        
        do {
            let allItems = try context.fetch(request)
            
           
            let allWords: [VocabularyWord] = allItems.compactMap { item in
                guard let english = item.english, let sinhala = item.sinhala, let category = item.category else {
                    return nil
                }
                return VocabularyWord(
                    english: english,
                    sinhala: sinhala,
                    category: category,
                    difficulty: Int(item.difficulty),
                    isLearned: item.isLearned,
                    isFavorite: item.isFavorite
                )
            }
            
            guard !allWords.isEmpty else { return [] }
            
            
            let slice = Array(allWords.dropFirst(lastIndex).prefix(limit))
            
        
            let newIndex = min(lastIndex + slice.count, allWords.count)
            UserDefaults.standard.set(newIndex, forKey: "lastVocabularyIndex")
            
            return slice
        } catch {
            print("Error fetching words: \(error)")
            return []
        }
    }
}

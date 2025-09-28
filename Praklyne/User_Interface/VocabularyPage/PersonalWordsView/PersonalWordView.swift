import SwiftUI
import CoreData

struct PersonalWordsView: View {
    let words: [VocabularyWord]
    let onAddWord: () -> Void
    @AppStorage("personalLearnedWords") private var personalLearnedWordsData: Data = Data()
    @State private var personalLearnedWords: Set<UUID> = []
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                addWordCard

                if words.isEmpty {
                    emptyStateView
                } else {
                    ForEach(words) { word in
                        WordCard(
                            word: word,
                            isLearned: personalLearnedWords.contains(word.id),
                            onToggleLearned: {
                                if personalLearnedWords.contains(word.id) {
                                    personalLearnedWords.remove(word.id)
                                } else {
                                    personalLearnedWords.insert(word.id)
                                }
                                savePersonalLearnedWords()
                            },
                            onDelete: {
                                deleteWord(word)
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .onAppear {
            loadPersonalLearnedWords()
        }
    }
    
    private func deleteWord(_ word: VocabularyWord) {
        let request: NSFetchRequest<VocabularyItem> = VocabularyItem.fetchRequest()
        request.predicate = NSPredicate(format: "english == %@ AND sinhala == %@", word.english, word.sinhala)
        do {
            let items = try viewContext.fetch(request)
            items.forEach { viewContext.delete($0) }
            try viewContext.save()
        } catch {
            print("Failed to delete word: \(error)")
        }
    }
    
    private var addWordCard: some View {
        Button(action: onAddWord) {
            HStack(spacing: 16) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Add New Word")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Build your personal vocabulary")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.body)
                    .foregroundColor(.gray)
            }
            .padding(20)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.1), Color.orange.opacity(0.05)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No Personal Words Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Start building your personal vocabulary by adding words you want to learn")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Button(action: onAddWord) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Your First Word")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.orange)
                .cornerRadius(12)
            }
        }
        .padding(40)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private func savePersonalLearnedWords() {
        let wordIds = Array(personalLearnedWords).map { $0.uuidString }
        if let encoded = try? JSONEncoder().encode(wordIds) {
            personalLearnedWordsData = encoded
        }
    }
    
    private func loadPersonalLearnedWords() {
        if let decoded = try? JSONDecoder().decode([String].self, from: personalLearnedWordsData) {
            personalLearnedWords = Set(decoded.compactMap { UUID(uuidString: $0) })
        }
    }
}







import SwiftUI


struct ImportantWordsView: View {
    let words: [VocabularyWord]
    @AppStorage("learnedWords") private var learnedWordsData: Data = Data()
    @State private var learnedWords: Set<UUID> = []
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
           
                progressOverviewCard
                
       
                ForEach(words) { word in
                    WordCard(
                        word: word,
                        isLearned: learnedWords.contains(word.id),
                        onToggleLearned: {
                            if learnedWords.contains(word.id) {
                                learnedWords.remove(word.id)
                            } else {
                                learnedWords.insert(word.id)
                            }
                            saveLearnedWords()
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .onAppear {
            loadLearnedWords()
            NotificationManager.shared.scheduleDailyVocabularyNotifications(words: words)
        }
        
    }
    
    private var progressOverviewCard: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Learning Progress")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(learnedWords.count)/\(words.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
 
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: geometry.size.width * (words.isEmpty ? 0 : Double(learnedWords.count) / Double(words.count)), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Learned")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(learnedWords.count)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Completion")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(Int((words.isEmpty ? 0 : Double(learnedWords.count) / Double(words.count)) * 100))%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
    
    private func saveLearnedWords() {
        let wordIds = Array(learnedWords).map { $0.uuidString }
        if let encoded = try? JSONEncoder().encode(wordIds) {
            learnedWordsData = encoded
        }
    }
    
    private func loadLearnedWords() {
        if let decoded = try? JSONDecoder().decode([String].self, from: learnedWordsData) {
            learnedWords = Set(decoded.compactMap { UUID(uuidString: $0) })
        }
    }
}



import SwiftUI


struct VocabularyWord: Identifiable, Hashable {
    let id = UUID()
    let english: String
    let sinhala: String
    let category: String
    let difficulty: Int 
    var isLearned: Bool = false
    var isFavorite: Bool = false
}

struct VocabularyStats {
    let totalWords: Int
    let learnedWords: Int
    let weeklyGoal: Int
    let currentStreak: Int
    
    var progressPercentage: Double {
        guard totalWords > 0 else { return 0 }
        return Double(learnedWords) / Double(totalWords)
    }
}


struct VocabularyView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showingAddWord = false
    @State private var personalWords: [VocabularyWord] = []
    @State private var importantWords: [VocabularyWord] = sampleImportantWords
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
       
                headerView
                
       
                tabNavigationView
                
    
                TabView(selection: $selectedTab) {
                    ImportantWordsView(words: filteredImportantWords)
                        .tag(0)
                    
                    PersonalWordsView(
                        words: filteredPersonalWords,
                        onAddWord: { showingAddWord = true }
                    )
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddWord) {
            AddWordView { word in
                personalWords.append(word)
            }
        }
    }
    

    private var headerView: some View {
        VStack(spacing: 16) {

            HStack {
                Button(action: {}) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Vocabulary Builder")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "gear")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
   
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search words...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    

    private var tabNavigationView: some View {
        HStack(spacing: 0) {
            TabButton(
                title: "3000 Important Words",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            TabButton(
                title: "Personal Vocabulary",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    

    private var filteredImportantWords: [VocabularyWord] {
        if searchText.isEmpty {
            return importantWords
        }
        return importantWords.filter { word in
            word.english.localizedCaseInsensitiveContains(searchText) ||
            word.sinhala.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredPersonalWords: [VocabularyWord] {
        if searchText.isEmpty {
            return personalWords
        }
        return personalWords.filter { word in
            word.english.localizedCaseInsensitiveContains(searchText) ||
            word.sinhala.localizedCaseInsensitiveContains(searchText)
        }
    }
}


struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .orange : .gray)
                    .multilineTextAlignment(.center)
                
                Rectangle()
                    .fill(isSelected ? Color.orange : Color.clear)
                    .frame(height: 3)
                    .cornerRadius(1.5)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


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


struct PersonalWordsView: View {
    let words: [VocabularyWord]
    let onAddWord: () -> Void
    @AppStorage("personalLearnedWords") private var personalLearnedWordsData: Data = Data()
    @State private var personalLearnedWords: Set<UUID> = []
    
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

struct WordCard: View {
    let word: VocabularyWord
    let isLearned: Bool
    let onToggleLearned: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
      
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(word.english)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
             
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { level in
                            Circle()
                                .fill(level <= word.difficulty ? Color.orange : Color.gray.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                
                Text(word.sinhala)
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text(word.category.uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            }
            
       
            Button(action: onToggleLearned) {
                Image(systemName: isLearned ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isLearned ? .green : .gray)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}


struct AddWordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var englishWord = ""
    @State private var sinhalaTranslation = ""
    @State private var selectedCategory = "General"
    @State private var selectedDifficulty = 3
    
    let onAddWord: (VocabularyWord) -> Void
    
    let categories = ["General", "Academic", "Business", "Technology", "Science", "Arts"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Word Details")) {
                    TextField("English Word", text: $englishWord)
                    TextField("Sinhala Translation", text: $sinhalaTranslation)
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Difficulty Level")) {
                    HStack {
                        Text("Easy")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Slider(value: Binding(
                            get: { Double(selectedDifficulty) },
                            set: { selectedDifficulty = Int($0) }
                        ), in: 1...5, step: 1)
                        
                        Text("Hard")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        ForEach(1...5, id: \.self) { level in
                            Circle()
                                .fill(level <= selectedDifficulty ? Color.orange : Color.gray.opacity(0.3))
                                .frame(width: 12, height: 12)
                        }
                    }
                }
            }
            .navigationTitle("Add New Word")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let newWord = VocabularyWord(
                        english: englishWord,
                        sinhala: sinhalaTranslation,
                        category: selectedCategory,
                        difficulty: selectedDifficulty
                    )
                    onAddWord(newWord)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(englishWord.isEmpty || sinhalaTranslation.isEmpty)
            )
        }
    }
}


let sampleImportantWords: [VocabularyWord] = [
    VocabularyWord(english: "abandon", sinhala: "අත්හැරීම", category: "General", difficulty: 3),
    VocabularyWord(english: "ability", sinhala: "හැකියාව", category: "General", difficulty: 2),
    VocabularyWord(english: "able", sinhala: "හැකි", category: "General", difficulty: 1),
    VocabularyWord(english: "about", sinhala: "ගැන", category: "General", difficulty: 1),
    VocabularyWord(english: "above", sinhala: "ඉහත", category: "General", difficulty: 2),
    VocabularyWord(english: "abroad", sinhala: "විදේශ", category: "General", difficulty: 3),
    VocabularyWord(english: "absence", sinhala: "නොමැතිකම", category: "General", difficulty: 3),
    VocabularyWord(english: "absolute", sinhala: "නිරපේක්ෂ", category: "Academic", difficulty: 4),
    VocabularyWord(english: "accept", sinhala: "පිළිගන්නවා", category: "General", difficulty: 2),
    VocabularyWord(english: "access", sinhala: "ප්‍රවේශය", category: "Technology", difficulty: 3),
    VocabularyWord(english: "accident", sinhala: "අනතුර", category: "General", difficulty: 2),
    VocabularyWord(english: "account", sinhala: "ගිණුම", category: "Business", difficulty: 2),
    VocabularyWord(english: "accurate", sinhala: "නිවැරදි", category: "Academic", difficulty: 3),
    VocabularyWord(english: "achieve", sinhala: "සාක්ෂාත් කරගන්නවා", category: "General", difficulty: 3),
    VocabularyWord(english: "across", sinhala: "හරහා", category: "General", difficulty: 2),
    VocabularyWord(english: "action", sinhala: "ක්‍රියාව", category: "General", difficulty: 2),
    VocabularyWord(english: "active", sinhala: "ක්‍රියාශීලී", category: "General", difficulty: 2),
    VocabularyWord(english: "actual", sinhala: "සැබෑ", category: "General", difficulty: 3),
    VocabularyWord(english: "address", sinhala: "ලිපිනය", category: "General", difficulty: 2),
    VocabularyWord(english: "administration", sinhala: "පරිපාලනය", category: "Business", difficulty: 4),
    VocabularyWord(english: "admit", sinhala: "පිළිගන්නවා", category: "General", difficulty: 3),
    VocabularyWord(english: "adult", sinhala: "වැඩිහිටියා", category: "General", difficulty: 1),
    VocabularyWord(english: "advance", sinhala: "ප්‍රගතිය", category: "General", difficulty: 3),
    VocabularyWord(english: "advantage", sinhala: "වාසිය", category: "General", difficulty: 3),
    VocabularyWord(english: "adventure", sinhala: "වික්‍රමය", category: "General", difficulty: 3),
    VocabularyWord(english: "advice", sinhala: "උපදෙස්", category: "General", difficulty: 2),
    VocabularyWord(english: "affair", sinhala: "කාරණය", category: "General", difficulty: 3),
    VocabularyWord(english: "affect", sinhala: "බලපෑම් කරනවා", category: "Academic", difficulty: 4),
    VocabularyWord(english: "afford", sinhala: "දරාගන්න පුළුවන්", category: "General", difficulty: 3),
    VocabularyWord(english: "afraid", sinhala: "බිය", category: "General", difficulty: 2)
]


struct VocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
          
            VocabularyView()
                .previewDisplayName("Default")
            
         
            VocabularyView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
        
            VocabularyView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            
      
            VocabularyView()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewDisplayName("iPad")
        }
    }
}

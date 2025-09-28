import SwiftUI
import CoreData

struct VocabularyView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showingAddWord = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \VocabularyItem.english, ascending: true)],
        animation: .default
    ) private var personalWordsCore: FetchedResults<VocabularyItem>
    
    @State private var importantWords: [VocabularyWord] = sampleImportantWords
    
    var body: some View {
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
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .sheet(isPresented: $showingAddWord) {
            AddWordView { word in
                let newItem = VocabularyItem(context: viewContext)
                newItem.id = UUID()
                newItem.english = word.english
                newItem.sinhala = word.sinhala
                newItem.category = word.category
                newItem.difficulty = Int16(word.difficulty)
                newItem.isLearned = false
                newItem.isFavorite = false
                do {
                    try viewContext.save()
                } catch {
                    print("Failed to save word: \(error)")
                }
            }
        }
    }

   
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Vocabulary Section")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
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
        if searchText.isEmpty { return importantWords }
        return importantWords.filter { word in
            word.english.localizedCaseInsensitiveContains(searchText) ||
            word.sinhala.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var filteredPersonalWords: [VocabularyWord] {
        personalWordsCore.compactMap { item -> VocabularyWord? in
            if let english = item.english,
               let sinhala = item.sinhala,
               let category = item.category {
                if searchText.isEmpty ||
                    english.localizedCaseInsensitiveContains(searchText) ||
                    sinhala.localizedCaseInsensitiveContains(searchText) {
                    
                    return VocabularyWord(
                        english: english,
                        sinhala: sinhala,
                        category: category,
                        difficulty: Int(item.difficulty),
                        isLearned: item.isLearned,
                        isFavorite: item.isFavorite
                    )
                }
            }
            return nil
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



struct VocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
          
            VocabularyView()
                .previewDisplayName("Default")
            
         
            VocabularyView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
        }
    }
}

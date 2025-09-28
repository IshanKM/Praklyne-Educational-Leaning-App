import SwiftUI

struct AddWordView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var englishWord = ""
    @State private var sinhalaTranslation = ""
    @State private var selectedCategory = "General"
    @State private var selectedDifficulty  = 3
    
    let onAddWord: (VocabularyWord) -> Void
    
    let categories = ["General", "Academic", "Business", "Technology", "Science", "Arts"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Word Details")) {
                    TextField("English Word", text: $englishWord)
                    TextField("Meaning of the word", text: $sinhalaTranslation)
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



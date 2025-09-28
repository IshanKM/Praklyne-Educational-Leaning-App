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


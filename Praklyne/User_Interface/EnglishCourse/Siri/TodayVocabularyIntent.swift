import AppIntents
import CoreData

struct TodayVocabularyIntent: AppIntent {
    
    static var title: LocalizedStringResource = "give me Today's Words in praklyne"
    
    static var description = IntentDescription("Fetches and speaks 5 personal vocabulary words with their meanings.")
    
    @Parameter(title: "Number of Words", default: 5)
    var limit: Int
    
    @MainActor
    func perform() async throws -> some ProvidesDialog {
        let context = VocabularyPersistenceController.shared.container.viewContext
        
        let words = VocabularyManager.shared.getWordsForToday(limit: limit, context: context)
        
        if words.isEmpty {
            return .result(dialog: IntentDialog("You don’t have any personal vocabulary words saved yet."))
        }
        
        // Build message with word + meaning
        let message = words.map { "\($0.english): \($0.sinhala)" }.joined(separator: ", ")
        
        return .result(dialog: IntentDialog(stringLiteral: "Here are your words: \(message)"))
    }
}

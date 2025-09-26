import AppIntents
import SwiftUI

struct CourseProgressIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Check english Course Progress in praklyne"
    
    static var description = IntentDescription("Check how many days you have completed in your 1-month English course.")

    @MainActor
    func perform() async throws -> some ProvidesDialog {
       
        let completedDays = UserDefaults.standard.integer(forKey: "totalDaysCompleted")
        let totalDays = 28
        let daysLeft = totalDays - completedDays

        let message = "You have completed \(completedDays) out of \(totalDays) days. Only \(daysLeft) days left!"


        return .result(dialog: IntentDialog(stringLiteral: message))
    }
}

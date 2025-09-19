import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder"
        content.body = "Don’t forget to complete today’s English learning task!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled")
            }
        }
    }
    
    func scheduleDailyReminder(hour: Int, minute: Int) {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Practice Reminder"
        content.body = "Your daily English task is waiting!"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "daily-reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    

    func sendEnrollmentNotification(for courseTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Enrolled Successfully 🎉"
        content.body = "You have enrolled in \(courseTitle). Get ready to start learning!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: "enrollment-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Enrollment notification error: \(error.localizedDescription)")
            } else {
                print("✅ Enrollment notification scheduled for \(courseTitle)")
            }
        }
    }
}

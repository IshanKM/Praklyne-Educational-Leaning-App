import Foundation
import UserNotifications

// MARK: - Notification Item Model
struct NotificationItem: Identifiable, Codable {
    let id: UUID
    let title: String
    let body: String
    let date: Date
    var isRead: Bool
}

// MARK: - Notification History Store (Local Inbox)
class NotificationHistoryStore: ObservableObject {
    static let shared = NotificationHistoryStore()
    
    @Published var items: [NotificationItem] = []
    
    private init() {
        loadFromUserDefaults()
    }
    
    func loadFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "notification_history_inbox"),
           let decoded = try? JSONDecoder().decode([NotificationItem].self, from: data) {
            self.items = decoded.sorted(by: { $0.date > $1.date })
        }
    }
    
    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: "notification_history_inbox")
        }
    }
    
    func addNotification(title: String, body: String, date: Date) {
        // Prevent duplicate entries of the same notification content delivered around the same time (within 5 seconds)
        let isDuplicate = items.contains { item in
            item.title == title && item.body == body && abs(item.date.timeIntervalSince(date)) < 5
        }
        guard !isDuplicate else { return }
        
        let newItem = NotificationItem(id: UUID(), title: title, body: body, date: date, isRead: false)
        DispatchQueue.main.async {
            self.items.insert(newItem, at: 0)
            self.saveToUserDefaults()
        }
    }
    
    func syncWithSystemDeliveredNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { [weak self] notifications in
            guard let self = self else { return }
            for notification in notifications {
                let title = notification.request.content.title
                let body = notification.request.content.body
                let date = notification.date
                self.addNotification(title: title, body: body, date: date)
            }
            // Trigger UI update on main thread
            DispatchQueue.main.async {
                self.loadFromUserDefaults()
            }
        }
    }
    
    func markAllAsRead() {
        for index in 0..<items.count {
            items[index].isRead = true
        }
        saveToUserDefaults()
        objectWillChange.send()
    }
    
    func deleteItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveToUserDefaults()
    }
    
    func clearAll() {
        items = []
        saveToUserDefaults()
        // Also clear delivered notifications from iOS notification center
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

// MARK: - Notification Manager
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
    
    func cancelDailyReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily-reminder"])
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
    
    
    func scheduleDailyVocabularyNotifications(words: [VocabularyWord], testMode: Bool = false) {
       
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["daily-vocab-1", "daily-vocab-2", "daily-vocab-3"])
        
        let currentIndex = UserDefaults.standard.integer(forKey: "vocabNotificationIndex")
        guard !words.isEmpty else { return }


        let countToSchedule = testMode ? min(5, words.count) : 1
        
        for i in 0..<countToSchedule {
            let wordIndex = (currentIndex + i) % words.count
            let word = words[wordIndex]
            
            let content = UNMutableNotificationContent()
            content.title = "Daily Word 📚"
            content.body = "\(word.english) → \(word.sinhala)"
            content.sound = .default
            
            let trigger: UNNotificationTrigger
            if testMode {
              
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(10 * (i + 1)), repeats: false)
            } else {
              
                var dateComponents = DateComponents()
                dateComponents.hour = 9
                dateComponents.minute = 0
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            }
            
            let request = UNNotificationRequest(
                identifier: "daily-vocab-\(word.id)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Vocab notification error: \(error.localizedDescription)")
                } else {
                    print("✅ Vocab scheduled: \(word.english) (in testMode: \(testMode))")
                }
            }
        }
        
      
        let nextIndex = (currentIndex + countToSchedule) % words.count
        UserDefaults.standard.set(nextIndex, forKey: "vocabNotificationIndex")
    }
}

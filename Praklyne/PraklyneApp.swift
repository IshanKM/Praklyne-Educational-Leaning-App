import SwiftUI
import FirebaseCore
import GoogleSignIn
import UserNotifications

@main
struct PraklyneApp: App {
    init() {
        FirebaseApp.configure()
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView() 
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Permission granted: \(granted)")
            }
        }
    }
}

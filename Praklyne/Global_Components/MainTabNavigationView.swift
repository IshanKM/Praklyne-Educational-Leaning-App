import SwiftUI

struct MainTabNavigationView: View {
    @Binding var selectedTab: Int
    @Binding var user: UserModel?
    @ObservedObject var lockManager: LockManager

    @State private var fullScreenActive: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case 0:
                    HomeView(user: $user)
                case 1:
                    ComingSoonView()
                case 2:
                    VideoShortsView()
                case 3:
                    ComingSoonView()
                case 4:
                    SettingsView(user: $user, lockManager: lockManager)
                default:
                    HomeView(user: $user)
                }
            }
            
            // Bottom navigation now always shows except for real fullscreen views
            if !fullScreenActive {
                BottomNavigationView(selectedTab: $selectedTab)
                    .background(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
            }
        }
    }
}

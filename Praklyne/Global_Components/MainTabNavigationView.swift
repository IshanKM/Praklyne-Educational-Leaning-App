import SwiftUI

struct MainTabNavigationView: View {
    @Binding var selectedTab: Int
    @Binding var user: UserModel?
    @ObservedObject var lockManager: LockManager

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case 0:
                    HomeView(user: $user)
                case 2:
                    VideoShortsView()
                case 4:
                    SettingsView(lockManager: lockManager)  // Profile
                default:
                    HomeView(user: $user)
                }
            }
            
            BottomNavigationView(selectedTab: $selectedTab)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
        }
    }
}


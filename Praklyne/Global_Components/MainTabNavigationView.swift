import SwiftUI

struct MainTabNavigationView: View {
    @Binding var selectedTab: Int
    @Binding var user: UserModel?

    var body: some View {
        ZStack {
            switch selectedTab {
            case 0:
                HomeView(user: $user)
            case 2:
                VideoShortsView()
            default:
                HomeView(user: $user)  
            }
        }
        .overlay(
            //BottomNavigationView(selectedTab: $selectedTab)
            BottomNavigationView(selectedTab: $selectedTab)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2),
            alignment: .bottom
        )
    }
}

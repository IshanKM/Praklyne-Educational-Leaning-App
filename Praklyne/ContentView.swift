import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var user: UserModel?
    @State private var selectedTab: Int = 0

    var body: some View {
        Group {
            if user == nil {
                SignInView(user: $user)
            } else {
                MainTabNavigationView(selectedTab: $selectedTab, user: $user)
            }
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                self.user = UserModel(user: currentUser)
            }
        }
    }
}

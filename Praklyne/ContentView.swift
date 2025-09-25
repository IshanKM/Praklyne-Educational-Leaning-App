import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var user: UserModel?
    
    var body: some View {
        Group {
            if let _ = user {
                RootView(user: $user)
            } else {
                LoginView(user: $user)
            }
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                self.user = UserModel(user: currentUser)
            }
        }
    }
}

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var user: UserModel?
    
    var body: some View {
        Group {
            if let user = user {

                RootView(user: $user)
            } else {
                SignInView(user: $user)
            }
        }
        .onAppear {
            if let currentUser = Auth.auth().currentUser {
                self.user = UserModel(user: currentUser)
            }
        }
    }
}

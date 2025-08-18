import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var user: UserModel?
    
    var body: some View {
        Group {
            if user == nil {
                SignInView(user: $user)
            } else {
                HomeView(user: $user)
            }
        }
        .onAppear {
            
            if let currentUser = Auth.auth().currentUser {
                self.user = UserModel(user: currentUser)
            }
        }
    }
}

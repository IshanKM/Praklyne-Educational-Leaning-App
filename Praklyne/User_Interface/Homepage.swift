import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var user: UserModel?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, \(user?.displayName ?? "User")")
                .font(.largeTitle)
                .bold()
            
            Text("Email: \(user?.email ?? "N/A")")
                .font(.subheadline)
            
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    user = nil       
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.top, 40)
        }
        .padding()
    }
}

struct HomeViewView_Previews: PreviewProvider {
    @State static var previewUser: UserModel? = nil

    static var previews: some View {
        HomeView(user: $previewUser)
    }
}

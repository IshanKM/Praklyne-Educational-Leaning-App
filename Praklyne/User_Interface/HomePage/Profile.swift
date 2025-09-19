import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var navigateToFaceID = false
    @Environment(\.presentationMode) var presentationMode
    @State private var user: UserModel?
    @ObservedObject var lockManager: LockManager
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            VStack(spacing: 16) {
                if let url = Auth.auth().currentUser?.photoURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Circle().fill(Color.gray.opacity(0.3))
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .padding(.top, 30)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.top, 30)
                }
                
                VStack(spacing: 4) {
                    Text(Auth.auth().currentUser?.displayName ?? "Unknown User")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Text(Auth.auth().currentUser?.email ?? "No email")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                  
                }) {
                    VStack(spacing: 2) {
                        Text("Enroll Courses")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Text("01")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(width: 140, height: 50)
                    .background(Color.green)
                    .cornerRadius(8)
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 40)
            
       
            VStack(spacing: 0) {
                SettingsMenuItem(title: "Notifications") { }
                SettingsMenuItem(title: "Face ID") {
                    navigateToFaceID = true
                }
                SettingsMenuItem(title: "About") { }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
       
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    
                    UIApplication.shared.windows.first?.rootViewController =
                        UIHostingController(rootView: LoginView(user: $user))
                } catch {
                    print("Error signing out: \(error)")
                }
            }) {
                Text("Logout")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $navigateToFaceID) {
            FaceIDView(lockManager: lockManager)
        }
    }
}


struct SettingsMenuItem: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 16)
        }
        .background(Color.white)
    }
}

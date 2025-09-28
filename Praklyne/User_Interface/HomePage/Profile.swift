import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @Binding var user: UserModel?
    @State private var navigateToFaceID = false
    @State private var navigateToNotifications = false
    @State private var navigateToAbout = false
    @ObservedObject var lockManager: LockManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Profile section with extra top padding
                VStack(spacing: 16) {
                    if let url = Auth.auth().currentUser?.photoURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Circle().fill(Color.gray.opacity(0.3))
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.top, 80) // extra space for notch
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                            .padding(.top, 80) // extra space for notch
                            .shadow(radius: 5)
                    }
                    
                    VStack(spacing: 4) {
                        Text(Auth.auth().currentUser?.displayName ?? "Unknown User")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(Auth.auth().currentUser?.email ?? "No email")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {}) {
                        VStack(spacing: 2) {
                            Text("Enroll Courses")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Text("01")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    .padding(.top, 12)
                }
                .padding(.bottom, 40)
                
                // Menu items
                VStack(spacing: 0) {
                    SettingsMenuItem(title: "Notifications") {
                        navigateToNotifications = true
                    }
                    SettingsMenuItem(title: "Face ID") {
                        navigateToFaceID = true
                    }
                    SettingsMenuItem(title: "About") {
                        navigateToAbout = true
                    }
                }
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Logout button
                Button(action: {
                    logout()
                }) {
                    Text("Logout")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(25)
                        .shadow(radius: 3)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .ignoresSafeArea()
            
            // Navigation
            .fullScreenCover(isPresented: $navigateToFaceID) {
                FaceIDView(lockManager: lockManager)
            }
            .background(
                NavigationLink(destination: NotificationsView(), isActive: $navigateToNotifications) { EmptyView() }
                    .hidden()
            )
            .background(
                NavigationLink(destination: AboutView(), isActive: $navigateToAbout) { EmptyView() }
                    .hidden()
            )
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
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
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 12)
            .background(Color.white)
        }
    }
}

// About Page
struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image("main_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 6)
                    .padding(.top, 40)
                
                Text("About Our App")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("""
Welcome to our learning app!  

Our platform combines **theory with practical knowledge**, giving practical knowlege experience while learning essential concepts. You can practice English,and other language follow a structured learning path, track your progress, and achieve your goals.  

Every course is designed to be interactive and engaging, helping you retain information and apply it in real-world scenarios. Daily challenges, videos, and summaries ensure you stay motivated and consistent.  

Start your journey today and unlock your potential with us!
""")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

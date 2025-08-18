import SwiftUI
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

struct SignInView: View {
    @Binding var user: UserModel?

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Image("praklyne_banner")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 280)
                    .clipped()

                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)

                        Image("praklyne_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 70, height: 70)
                    }
                    .offset(y: -50)

                    VStack(spacing: 16) {
                        Text("Welcome !")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, -30)

                        VStack(spacing: 16) {
                            Text("Sign in or Create an Account")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.orange)
                                .padding(.top, 20)
                            
                 
                            SignInWithAppleButton(
                                onRequest: { request in
                                    request.requestedScopes = [.fullName, .email]
                                },
                                onCompletion: { result in
                                    switch result {
                                    case .success(let authorization):
                                        if let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                            FirebaseManager.shared.signInWithApple(credential: appleCredential) { res in
                                                switch res {
                                                case .success(let authResult):
                                                    user = UserModel(user: authResult.user)
                                                case .failure(let error):
                                                    print("Apple SignIn Error: \(error.localizedDescription)")
                                                }
                                            }
                                        }
                                    case .failure(let error):
                                        print("Apple Sign In Error: \(error.localizedDescription)")
                                    }
                                }
                            )
                            .signInWithAppleButtonStyle(.black)
                            .frame(height: 50)
                            .cornerRadius(25)
                            .padding(.horizontal, 20)
                            
                      
                            Button(action: {
                                FirebaseManager.shared.signInWithGoogle { res in
                                    switch res {
                                    case .success(let authResult):
                                        user = UserModel(user: authResult.user)
                                    case .failure(let error):
                                        print("Google SignIn Error: \(error.localizedDescription)")
                                    }
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "globe")
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                    Text("Continue with Google")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .cornerRadius(25)
                            }
                            .padding(.horizontal, 20)

                        }
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                }
                .background(Color.white)
                .cornerRadius(20)
                .offset(y: -20)
                .padding(.top, 20)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .background(Color.white)
    }
}






import SwiftUI
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @Binding var user: UserModel?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
 
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Spacer()
                        Text("9:41")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Image("praklyne_banner")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                }
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.7, green: 0.9, blue: 0.7),
                            Color(red: 0.5, green: 0.8, blue: 0.5)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Spacer()
            }
            .ignoresSafeArea()
            
         
            VStack {
                Spacer()
                    .frame(height: 280)
                
                VStack(spacing: 24) {
             
                    Image("main_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 80)
                        .clipShape(Circle())
                        .padding(.top, 30)
                    
           
                    VStack(spacing: 16) {
                        Text("Welcome !")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("BoostEnGuide is your path to English fluency in one month. Learn with documentaries and track vocabulary, and practice speaking and writing with AI-powered tools. Start improving your English skills today!")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                    .padding(.horizontal, 20)
                    
         
                    VStack(spacing: 20) {
                        Text("Sign in or Create an Account")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                        
        
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
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
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
                                Image("googlelogo")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                
                                Text("Continue with Google")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(colorScheme == .dark ? .black : .black)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
              
                    VStack(spacing: 4) {
                        Text("By signing in to BoostEnGuide, you agree to our")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Button("Terms") {
                            
                            }
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                            
                            Text("and")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Button("Privacy Policy") {
                             
                            }
                            .font(.system(size: 12))
                            .foregroundColor(.blue)
                            
                            Text(".")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView(user: .constant(nil))
                .preferredColorScheme(.light)
            
            LoginView(user: .constant(nil))
                .preferredColorScheme(.dark)
        }
    }
}

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @Binding var user: UserModel?
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var welcomeOffset: CGFloat = 50
    @State private var welcomeOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 50
    @State private var buttonsOpacity: Double = 0
    @State private var bannerOffset: CGFloat = -100
    @State private var bannerOpacity: Double = 0
    @State private var applePressed = false
    @State private var googlePressed = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image("praklyne_banner")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                        .offset(y: bannerOffset)
                        .opacity(bannerOpacity)
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
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                )
                
                Spacer()
            }
            
            VStack {
                Spacer()
                    .frame(height: 280)
                
                VStack(spacing: 20) {
                    // Animated Logo
                    Image("main_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 80)
                        .clipShape(Circle())
                        .padding(.top, 30)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .shadow(color: Color(red: 0.5, green: 0.8, blue: 0.5).opacity(0.5), radius: 15, x: 0, y: 5)
                        .onAppear {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.7, blendDuration: 0)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                        }
                    
                    // Animated Welcome Text
                    VStack(spacing: 16) {
                        Text("Welcome !")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("Praklyne helps you master multiple subjects and languages with short videos, images, and AI-powered practice. Learn faster, stay engaged, and track your progress all in one place.")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 20)
                    }
                    .padding(.horizontal, 20)
                    .offset(y: welcomeOffset)
                    .opacity(welcomeOpacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                welcomeOffset = 0
                                welcomeOpacity = 1.0
                            }
                        }
                    }
                    
                    // Animated Authentication Buttons
                    VStack(spacing: 20) {
                        Text("Sign in or Create an Account")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.orange)
                        
                        // Apple Sign In Button with Animation
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
                        .scaleEffect(applePressed ? 0.95 : 1.0)
                        .opacity(buttonsOpacity)
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                applePressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    applePressed = false
                                }
                            }
                        }
                        
                        // Google Sign In Button with Animation
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                googlePressed = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    googlePressed = false
                                }
                            }
                            
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
                        .scaleEffect(googlePressed ? 0.95 : 1.0)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    .offset(y: buttonsOffset)
                    .opacity(buttonsOpacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.easeOut(duration: 0.6)) {
                                buttonsOffset = 0
                                buttonsOpacity = 1.0
                            }
                        }
                    }
                    
                    // Animated Terms and Privacy
                    VStack(spacing: 4) {
                        Text("By signing in to BoostEnGuide, you agree to our")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 4) {
                            Button("Terms") {}
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                            
                            Text("and")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Button("Privacy Policy") {}
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                            
                            Text(".")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    .offset(y: buttonsOffset)
                    .opacity(buttonsOpacity)
                }
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.7)) {
                    bannerOffset = 0
                    bannerOpacity = 1.0
                }
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

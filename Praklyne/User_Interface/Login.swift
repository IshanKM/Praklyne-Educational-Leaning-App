import SwiftUI
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    @Binding var user: UserModel?
    @Environment(\.colorScheme) var colorScheme
    
    @State private var bannerScale: CGFloat = 0.92
    @State private var bannerOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 30
    
    // Nonce for secure Apple Sign In
    @State private var currentNonce: String?
    
    // Animation states for floating glow blobs
    @State private var animateGlows = false
    
    var body: some View {
        ZStack {
            // ── Premium Deep Ambient Background ──
            ambientBackground
                .ignoresSafeArea()
            
            // ── Interactive Ambient Glow Blobs ──
            glowNodesSection
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // ── Header: Floating Banner & Glowing Logo Shield ──
                    headerSection
                        .padding(.top, 24)
                        
                    // ── Glassmorphic Login Card ──
                    VStack(spacing: 28) {
                        
                        // Welcome Branding Text
                        welcomeTextSection
                        
                        // Authentication Actions (Symmetrical Buttons)
                        authButtonsSection
                        
                        // Terms & Privacy Links
                        termsAndPrivacySection
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 36)
                    .background(
                        ZStack {
                            // Frosted glass backing
                            if colorScheme == .dark {
                                Color(hex: "#1E293B").opacity(0.65)
                            } else {
                                Color.white.opacity(0.75)
                            }
                        }
                        .background(.ultraThinMaterial)
                        .cornerRadius(32)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .stroke(
                                    LinearGradient(
                                        colors: colorScheme == .dark ? 
                                            [Color.white.opacity(0.15), Color.white.opacity(0.05)] : 
                                            [Color.white.opacity(0.60), Color.white.opacity(0.20)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.08), radius: 24, x: 0, y: 12)
                    )
                    .padding(.horizontal, 20)
                    .opacity(contentOpacity)
                    .offset(y: contentOffset)
                }
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            // Trigger floating background animations
            withAnimation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true)) {
                animateGlows = true
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                bannerScale = 1.0
                bannerOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.85)) {
                    contentOpacity = 1.0
                    contentOffset = 0
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var ambientBackground: some View {
        Color(colorScheme == .dark ? Color(hex: "#0A0F1D") : Color(hex: "#F8FAFC"))
    }
    
    // Floating animated background blobs for ambient depth
    private var glowNodesSection: some View {
        ZStack {
            // First Glow (Mint Green)
            Circle()
                .fill(Color(hex: "#10B981").opacity(colorScheme == .dark ? 0.15 : 0.18))
                .frame(width: 320, height: 320)
                .blur(radius: 65)
                .offset(x: animateGlows ? -80 : -140, y: animateGlows ? -200 : -260)
            
            // Second Glow (Indigo Purple)
            Circle()
                .fill(Color(hex: "#6C63FF").opacity(colorScheme == .dark ? 0.15 : 0.18))
                .frame(width: 350, height: 350)
                .blur(radius: 70)
                .offset(x: animateGlows ? 100 : 160, y: animateGlows ? 150 : 220)
        }
    }
    
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            // Floating Postcard Banner
            Image("praklyne_banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220)
                .frame(maxWidth: .infinity)
                .cornerRadius(24)
                .clipped()
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.1), radius: 16, x: 0, y: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.45), lineWidth: 1.5)
                )
                .scaleEffect(bannerScale)
                .opacity(bannerOpacity)
                .padding(.bottom, 36)
            
            // Floating Logo Shield in frosted border
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 86, height: 86)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(colorScheme == .dark ? 0.2 : 0.6), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 5)
                
                Image("main_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
            }
            .opacity(bannerOpacity)
            .scaleEffect(bannerScale)
        }
        .padding(.horizontal, 20)
    }
    
    private var welcomeTextSection: some View {
        VStack(spacing: 12) {
            Text("Welcome !")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Praklyne helps you master multiple subjects and languages with short videos, images, and AI-powered practice. Learn faster, stay engaged, and track your progress all in one place.")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 8)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var authButtonsSection: some View {
        VStack(spacing: 18) {
            Text("Sign in or Create Account")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .dark ? Color(hex: "#34D399") : Color(hex: "#059669"))
                .textCase(.uppercase)
                .tracking(1.2)
            
            // ── Apple Sign In Button (Strict iOS sizing and alignments) ──
            SignInWithAppleButton(
                onRequest: { request in
                    let nonce = FirebaseManager.shared.randomNonceString()
                    currentNonce = nonce
                    request.nonce = FirebaseManager.shared.sha256(nonce)
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        if let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                            FirebaseManager.shared.signInWithApple(credential: appleCredential, rawNonce: currentNonce) { res in
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
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .cornerRadius(26)
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.08), radius: 8, x: 0, y: 4)
            
            // ── Google Sign In Button ──
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
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 18, height: 18)
                    
                    Text("Continue with Google")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .black : .black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.white)
                .cornerRadius(26)
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.08), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(LoginScaleButtonStyle())
        }
        .padding(.top, 8)
    }
    
    private var termsAndPrivacySection: some View {
        VStack(spacing: 6) {
            Text("By signing in, you agree to Praklyne's")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            
            HStack(spacing: 4) {
                Button("Terms of Service") {}
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#1A73E8"))
                
                Text("and")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Button("Privacy Policy") {}
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#1A73E8"))
            }
        }
        .padding(.top, 12)
    }
}

// MARK: - Login Button Scale Transition Style
struct LoginScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .brightness(configuration.isPressed ? -0.03 : 0.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Previews
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

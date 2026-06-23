import SwiftUI

// MARK: - Onboarding Page Model
struct OnboardingPageData: Identifiable {
    let id: Int
    let imageName: String
    let title: String
    let description: String
}

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @State private var currentPage = 0
    @Environment(\.colorScheme) var colorScheme
    let onFinish: () -> Void
    
    private let pages = [
        OnboardingPageData(
            id: 0,
            imageName: "brainintro",
            title: "Learn Smarter, Not Harder",
            description: "Praklyne offers a structured and engaging way to learn, from language skills to science, mathematics, and programming — explore knowledge step by step with interactive videos, books, and practice exercises."
        ),
        OnboardingPageData(
            id: 1,
            imageName: "mountainintro",
            title: "Explore & Achieve More",
            description: "Go further with a variety of subjects, short educational videos, and reading materials. Stay secure with Face ID login and stay motivated with personalized progress tracking."
        ),
        OnboardingPageData(
            id: 2,
            imageName: "birdintro",
            title: "Practical Knowledge",
            description: "Apply what you learn with real-world examples and build skills that last a lifetime."
        )
    ]
    
    var body: some View {
        ZStack {
            // ── Background Ambient Glow ──
            ambientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ── Top Navigation Bar ──
                topNavigationBar
                
                // ── Swipeable Content (Illustration & Texts) ──
                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        OnboardingContentCard(page: page, activePage: currentPage)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // ── Bottom Fixed Action Area ──
                bottomActionArea
            }
        }
    }
    
    // MARK: - Subviews
    
    // Smooth dynamic ambient background gradient based on active page
    private var ambientBackground: some View {
        let colors: [Color]
        if colorScheme == .dark {
            switch currentPage {
            case 0: colors = [Color(hex: "#0F172A"), Color(hex: "#1E293B")] // Dark blue-slate
            case 1: colors = [Color(hex: "#1E1B4B"), Color(hex: "#0F172A")] // Dark purple-indigo
            default: colors = [Color(hex: "#064E3B"), Color(hex: "#0F172A")] // Dark emerald-slate
            }
        } else {
            switch currentPage {
            case 0: colors = [Color(hex: "#E0F2FE"), Color.white] // Soft sky-blue
            case 1: colors = [Color(hex: "#F3E8FF"), Color.white] // Soft lavender
            default: colors = [Color(hex: "#DCFCE7"), Color.white] // Soft mint-green
            }
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .animation(.easeInOut(duration: 0.6), value: currentPage)
    }
    
    // Top bar containing branding and Skip button
    private var topNavigationBar: some View {
        HStack {
            Text("Praklyne")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(primaryThemeColor)
            
            Spacer()
            
            if currentPage < 2 {
                Button(action: {
                    withAnimation {
                        onFinish()
                    }
                }) {
                    Text("Skip")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.04))
                        )
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
    
    // Bottom container for dots indicator and primary action button
    private var bottomActionArea: some View {
        VStack(spacing: 24) {
            // Dynamic pill-style pagination indicator
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Capsule()
                        .fill(currentPage == index ? primaryThemeColor : Color.secondary.opacity(0.3))
                        .frame(width: currentPage == index ? 24 : 8, height: 8)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
            
            // Next / Start Action Button
            Button(action: handleNextAction) {
                Text(currentPage == 2 ? "Get Started" : "Next")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: buttonColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(27)
                    .shadow(color: primaryThemeColor.opacity(0.3), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 24)
            }
            .buttonStyle(OnboardingScaleButtonStyle())
        }
        .padding(.bottom, safeAreaBottom() + 16)
    }
    
    // MARK: - Helpers
    
    private func handleNextAction() {
        if currentPage < 2 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                currentPage += 1
            }
        } else {
            onFinish()
        }
    }
    
    private var primaryThemeColor: Color {
        switch currentPage {
        case 0: return Color(hex: "#1A73E8") // Blue
        case 1: return Color(hex: "#6C63FF") // Indigo/Purple
        default: return Color(hex: "#10B981") // Emerald/Mint
        }
    }
    
    private var buttonColors: [Color] {
        switch currentPage {
        case 0: return [Color(hex: "#1A73E8"), Color(hex: "#00C6FF")]
        case 1: return [Color(hex: "#6C63FF"), Color(hex: "#B19FFB")]
        default: return [Color(hex: "#10B981"), Color(hex: "#34D399")]
        }
    }
    
    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

// MARK: - Onboarding Content Card
struct OnboardingContentCard: View {
    let page: OnboardingPageData
    let activePage: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // ── Floating Image Card with soft glow behind it ──
            ZStack {
                // Background radial glow
                Circle()
                    .fill(glowGradient)
                    .frame(width: 250, height: 250)
                    .blur(radius: 40)
                    .opacity(colorScheme == .dark ? 0.35 : 0.5)
                
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .cornerRadius(28)
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.12), radius: 24, x: 0, y: 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.white.opacity(colorScheme == .dark ? 0.15 : 0.55), lineWidth: 1.5)
                    )
            }
            .scaleEffect(activePage == page.id ? 1.0 : 0.85)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: activePage)
            
            Spacer()
            
            // ── Text Content ──
            VStack(spacing: 14) {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(page.description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .offset(y: activePage == page.id ? 0 : 30)
            .opacity(activePage == page.id ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.15), value: activePage)
            
            Spacer()
        }
    }
    
    private var glowGradient: RadialGradient {
        let centerColor: Color
        switch page.id {
        case 0: centerColor = Color(hex: "#1A73E8").opacity(0.3)
        case 1: centerColor = Color(hex: "#6C63FF").opacity(0.3)
        default: centerColor = Color(hex: "#10B981").opacity(0.3)
        }
        
        return RadialGradient(
            gradient: Gradient(colors: [centerColor, Color.clear]),
            center: .center,
            startRadius: 5,
            endRadius: 130
        )
    }
}

// MARK: - Scale Animation Button Style
struct OnboardingScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.05 : 0.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Previews
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView { }
    }
}

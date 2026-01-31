import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    // Logo animations
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0.0
    @State private var logoRotation: Double = -30
    
    // Ring animations
    @State private var ring1Scale: CGFloat = 0.5
    @State private var ring1Opacity: Double = 0.0
    @State private var ring2Scale: CGFloat = 0.5
    @State private var ring2Opacity: Double = 0.0
    @State private var ring3Scale: CGFloat = 0.5
    @State private var ring3Opacity: Double = 0.0
    @State private var ringRotation: Double = 0
    
    // Text animations
    @State private var textOpacity: Double = 0.0
    @State private var textOffset: CGFloat = 30
    
    // Particles
    @State private var showParticles = false
    
    // Background gradient animation
    @State private var gradientStart = UnitPoint(x: 0, y: 0)
    @State private var gradientEnd = UnitPoint(x: 1, y: 1)
    
    // Shimmer effect
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.6, blue: 0.4),
                    Color(red: 0.2, green: 0.8, blue: 0.5),
                    Color(red: 0.15, green: 0.7, blue: 0.45)
                ]),
                startPoint: gradientStart,
                endPoint: gradientEnd
            )
            .ignoresSafeArea()
            
            // Floating particles
            if showParticles {
                ParticlesView()
            }
            
            // Animated rings behind logo //
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .white.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 280, height: 280)
                    .scaleEffect(ring1Scale)
                    .opacity(ring1Opacity)
                    .rotationEffect(.degrees(ringRotation))
                
                // Middle ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.4), .white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 240, height: 240)
                    .scaleEffect(ring2Scale)
                    .opacity(ring2Opacity)
                    .rotationEffect(.degrees(-ringRotation * 0.7))
                
                // Inner ring with dash
                Circle()
                    .stroke(
                        style: StrokeStyle(lineWidth: 4, dash: [10, 5])
                    )
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 200, height: 200)
                    .scaleEffect(ring3Scale)
                    .opacity(ring3Opacity)
                    .rotationEffect(.degrees(ringRotation * 1.2))
                
                // Logo with glow effect
                ZStack {
                    // Glow layer
                    Image("main_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)
                        .opacity(logoOpacity * 0.5)
                    
                    // Main logo
                    Image("main_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .rotationEffect(.degrees(logoRotation))
                        .overlay(
                            // Shimmer effect
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .clear,
                                            .white.opacity(0.4),
                                            .clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 60)
                                .offset(x: shimmerOffset)
                                .mask(
                                    Image("main_logo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 150, height: 150)
                                )
                        )
                }
            }
            
            // App name and tagline
            VStack(spacing: 8) {
                Spacer()
                
                Text("Praklyne")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .offset(y: textOffset)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Text("Learn Smarter, Not Harder")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(textOpacity)
                    .offset(y: textOffset)
                
                Spacer().frame(height: 100)
                
                // Loading indicator
                LoadingDotsView()
                    .opacity(textOpacity)
                
                Spacer().frame(height: 60)
            }
        }
        .onAppear {
            startAnimations()
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
    
    func startAnimations() {
        // Animate gradient background
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            gradientStart = UnitPoint(x: 1, y: 1)
            gradientEnd = UnitPoint(x: 0, y: 0)
        }
        
        // Show particles
        withAnimation(.easeIn(duration: 0.5)) {
            showParticles = true
        }
        
        // Logo entrance animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
            logoScale = 1.0
            logoOpacity = 1.0
            logoRotation = 0
        }
        
        // Ring animations with staggered timing
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            ring1Scale = 1.0
            ring1Opacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
            ring2Scale = 1.0
            ring2Opacity = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
            ring3Scale = 1.0
            ring3Opacity = 1.0
        }
        
        // Continuous ring rotation
        withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
            ringRotation = 360
        }
        
        // Text animation
        withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
            textOpacity = 1.0
            textOffset = 0
        }
        
        // Shimmer animation
        withAnimation(.easeInOut(duration: 1.5).delay(1.0).repeatForever(autoreverses: false)) {
            shimmerOffset = 200
        }
        
        // Navigate after splash
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isActive = true
            }
        }
    }
}

// MARK: - Floating Particles
struct ParticlesView: View {
    var body: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                ParticleView(index: index)
            }
        }
    }
}

struct ParticleView: View {
    let index: Int
    @State private var opacity: Double = 0
    @State private var position: CGPoint = .zero
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        Circle()
            .fill(.white.opacity(0.3))
            .frame(width: CGFloat.random(in: 4...12))
            .scaleEffect(scale)
            .opacity(opacity)
            .position(position)
            .onAppear {
                let screenWidth = UIScreen.main.bounds.width
                let screenHeight = UIScreen.main.bounds.height
                
                position = CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                )
                
                let delay = Double(index) * 0.1
                let duration = Double.random(in: 2...4)
                
                withAnimation(.easeInOut(duration: duration).delay(delay).repeatForever(autoreverses: true)) {
                    opacity = Double.random(in: 0.2...0.6)
                    scale = CGFloat.random(in: 0.8...1.5)
                    position = CGPoint(
                        x: position.x + CGFloat.random(in: -50...50),
                        y: position.y + CGFloat.random(in: -100...(-20))
                    )
                }
            }
    }
}

// MARK: - Loading Dots Animation
struct LoadingDotsView: View {
    @State private var dot1Opacity: Double = 0.3
    @State private var dot2Opacity: Double = 0.3
    @State private var dot3Opacity: Double = 0.3
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(.white)
                .frame(width: 10, height: 10)
                .opacity(dot1Opacity)
            
            Circle()
                .fill(.white)
                .frame(width: 10, height: 10)
                .opacity(dot2Opacity)
            
            Circle()
                .fill(.white)
                .frame(width: 10, height: 10)
                .opacity(dot3Opacity)
        }
        .onAppear {
            animateDots()
        }
    }
    
    func animateDots() {
        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            dot1Opacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.2)) {
            dot2Opacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true).delay(0.4)) {
            dot3Opacity = 1.0
        }
    }
}

// MARK: - Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}


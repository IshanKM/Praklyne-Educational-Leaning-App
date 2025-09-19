import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onFinish: () -> Void
    
    var body: some View {
        TabView(selection: $currentPage) {
            
            OnboardingPage(
                imageName: "brainintro",
                backgroundColor: Color.yellow.opacity(0.8),
                title: "Learn Smarter, Not Harder",
                description: "Praklyne offers a structured and engaging way to learn, from language skills to science, mathematics, and programming — explore knowledge step by step with interactive videos, books, and practice exercises.",
                buttonText: "Next",
                isLastPage: false
            ) {
                withAnimation {
                    currentPage = 1
                }
            }
            .tag(0)
            
            OnboardingPage(
                imageName: "mountainintro",
                backgroundColor: Color.teal.opacity(0.7),
                title: "Explore & Achieve More",
                description: "Go further with a variety of subjects, short educational videos, and reading materials. Stay secure with Face ID login and stay motivated with personalized progress tracking.",
                buttonText: "Next",
                isLastPage: false
            ) {
                withAnimation {
                    currentPage = 2
                }
            }
            .tag(1)
            
            OnboardingPage(
                imageName: "birdintro",
                backgroundColor: Color.blue.opacity(0.7),
                title: "Practical Knowledge",
                description: "Apply what you learn with real examples and build skills that last a lifetime.",
                buttonText: "Start",
                isLastPage: true
            ) {
                onFinish()
            }
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.bottom, 100),
            alignment: .bottom
        )
    }
}

struct OnboardingPage: View {
    let imageName: String
    let backgroundColor: Color
    let title: String
    let description: String
    let buttonText: String
    let isLastPage: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                backgroundColor
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 280, height: 320)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .cornerRadius(12)
                    }
                    
                    Spacer()
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.6)
            Spacer()
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
                
                Button(action: action) {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .cornerRadius(25)
                        .padding(.horizontal, 32)
                }
                
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height * 0.4)
            .background(Color(.systemBackground))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView { }
    }
}

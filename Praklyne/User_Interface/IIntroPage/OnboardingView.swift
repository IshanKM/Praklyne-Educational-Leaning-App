import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    let onFinish: () -> Void
    
    var body: some View {
        TabView(selection: $currentPage) {
            
            OnboardingPage(
                imageName: "brainintro",
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
    let title: String
    let description: String
    let buttonText: String
    let isLastPage: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            VStack {
                Spacer()
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height * 0.6)
            .background(Color(.systemBackground))
            
            Spacer()
            
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 24)
                    
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 24)
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
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
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

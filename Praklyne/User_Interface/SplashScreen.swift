import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0

    var body: some View {
        ZStack {
      
            Color(red: 0.2, green: 0.8, blue: 0.4)
                .ignoresSafeArea()

            Image("main_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .animation(.easeInOut(duration: 1.0), value: logoScale)
                .animation(.easeInOut(duration: 1.0), value: logoOpacity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            ContentView()
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

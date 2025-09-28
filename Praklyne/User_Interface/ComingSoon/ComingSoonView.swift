import SwiftUI

struct ComingSoonView: View {
    var body: some View {
        ZStack {
         
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.1, green: 0.8, blue: 0.1), .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "hourglass.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(radius: 10)
                
                Text("Coming Soon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("This feature is under development.\nStay tuned!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
    }
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView()
    }
}

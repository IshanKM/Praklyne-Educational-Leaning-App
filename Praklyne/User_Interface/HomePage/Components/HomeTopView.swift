import SwiftUI

struct HeaderView: View {
    let user: UserModel?
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                HStack {
                    if let urlString = user?.photoURL,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Image("main_logo")
                                .resizable()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    } else {
                        Image("main_logo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: NotificationsView()) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 42, height: 42)
                            Image(systemName: "bell.fill")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                VStack(spacing: 2) {
                    Text("Hey \(user?.displayName?.split(separator: " ").first.map { String($0) } ?? "Learner")!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                    
                    Text("Learn Theory through Practical Knowledge")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 140)
            }
            .padding(.top, 10)
        }
        .padding(.bottom, 8)
    }
}

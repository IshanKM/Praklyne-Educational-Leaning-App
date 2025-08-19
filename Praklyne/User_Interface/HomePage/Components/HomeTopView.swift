import SwiftUI

struct HeaderView: View {
    let user: UserModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 8) {
     
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
                    } else {
                        Image("main_logo")
                            .resizable()
                            .frame(width: 80, height: 60)
                            .clipShape(Circle())
                    }


                    Text("Hey \(user?.displayName ?? "Learner")..!")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                Spacer()


                Button(action: {}) {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 10)

            Text("Learn Theory through Practical Knowledge")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

import SwiftUI

struct HeaderView: View {
    let user: UserModel?
    @Binding var selectedTab: Int

    var body: some View {
        HStack(alignment: .center, spacing: 12) {

            // MARK: – Avatar
            Button(action: {
                selectedTab = 4 // Switch to the Settings Tab
            }) {
                Group {
                    if let urlString = user?.photoURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Image("main_logo").resizable().scaledToFill()
                        }
                    } else {
                        Image("main_logo").resizable().scaledToFill()
                    }
                }
                .frame(width: 46, height: 46)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "#1A73E8"), Color(hex: "#9C27B0")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2.5
                        )
                )
                .shadow(color: Color(hex: "#1A73E8").opacity(0.25), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(.plain)

            // MARK: – Greeting
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text("Hey,")
                        .font(.system(size: 22, weight: .regular, design: .rounded))
                        .foregroundColor(.secondary)
                    Text("\(user?.displayName?.split(separator: " ").first.map { String($0) } ?? "Learner")! 👋")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#1A73E8"), Color(hex: "#9C27B0")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }

                Text("Learn Theory through Practical Knowledge")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // MARK: – Notification Bell
            NavigationLink(destination: NotificationsView()) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)

                    Image(systemName: "bell.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#1A73E8"), Color(hex: "#9C27B0")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }
}

// MARK: - Color hex helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

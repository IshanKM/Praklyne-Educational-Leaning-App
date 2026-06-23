import SwiftUI

struct SubjectCardView: View {
    let subject: Subject

    // Per-subject gradient pairs
    private var gradient: [Color] {
        switch subject.name {
        case "Science":     return [Color(hex: "#11998e"), Color(hex: "#38ef7d")]
        case "Maths":       return [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")]
        case "Programming": return [Color(hex: "#f953c6"), Color(hex: "#b91d73")]
        case "Business":    return [Color(hex: "#8E2DE2"), Color(hex: "#4A00E0")]
        case "History":     return [Color(hex: "#F7971E"), Color(hex: "#FFD200")]
        case "Geography":   return [Color(hex: "#11998e"), Color(hex: "#38ef7d")]
        default:            return [subject.color, subject.color.opacity(0.7)]
        }
    }

    var body: some View {
        NavigationLink(
            destination: TopicsListView(
                learningSubject: LearningSubject(id: subject.id, name: subject.name, color: subject.color)
            )
        ) {
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)
                        .shadow(color: gradient.first?.opacity(0.35) ?? .clear, radius: 8, x: 0, y: 4)

                    Image(systemName: subject.icon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.white)
                }

                Text(subject.name)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .frame(width: 88)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: – Scale-on-press interaction
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

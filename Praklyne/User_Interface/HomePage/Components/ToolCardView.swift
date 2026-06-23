import SwiftUI
import Foundation

struct ToolCardView: View {
    let tool: Tool

    // Per-tool gradient pairs for visual identity
    private var gradient: [Color] {
        switch tool.name {
        case "Your vocabulary list": return [Color(hex: "#F7971E"), Color(hex: "#FFD200")]
        case "Learning with AI":     return [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")]
        case "Listing Content":      return [Color(hex: "#11998e"), Color(hex: "#38ef7d")]
        case "Books":                return [Color(hex: "#8E2DE2"), Color(hex: "#4A00E0")]
        default:                     return [tool.color, tool.color.opacity(0.6)]
        }
    }

    var body: some View {
        NavigationLink(destination: destinationView(for: tool)) {
            HStack(spacing: 14) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .shadow(color: gradient.first?.opacity(0.3) ?? .clear, radius: 6, x: 0, y: 3)

                    Image(systemName: tool.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }

                // Label
                Text(tool.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator).opacity(0.4), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    @ViewBuilder
    private func destinationView(for tool: Tool) -> some View {
        switch tool.name {
        case "Your vocabulary list":
            VocabularyView()
        case "Learning with AI":
            AIChatView()
        case "Books":
            BooksView()
        default:
            ComingSoonView()
        }
    }
}

import SwiftUI

// MARK: - Right-Side Action Sidebar
struct VideoActionSidebar: View {
    let video: VideoData
    let isLiked: Bool
    let isSaved: Bool
    let onLike: () -> Void
    let onSave: () -> Void
    let onShare: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // ❤️ Like
            SidebarActionButton(
                icon: isLiked ? "heart.fill" : "heart",
                label: "Like",
                tint: isLiked
                    ? Color(red: 1.0, green: 0.25, blue: 0.35)
                    : .white,
                isActive: isLiked,
                glowColor: Color(red: 1.0, green: 0.25, blue: 0.35),
                action: onLike
            )

            // 🔖 Save
            SidebarActionButton(
                icon: isSaved ? "bookmark.fill" : "bookmark",
                label: "Save",
                tint: isSaved
                    ? Color(red: 0.25, green: 0.92, blue: 0.6)
                    : .white,
                isActive: isSaved,
                glowColor: Color(red: 0.25, green: 0.92, blue: 0.6),
                action: onSave
            )

            // ↗️ Share
            SidebarActionButton(
                icon: "arrowshape.turn.up.forward.fill",
                label: "Share",
                tint: .white,
                isActive: false,
                glowColor: .clear,
                action: onShare
            )
        }
    }
}

// MARK: - Individual Sidebar Button
struct SidebarActionButton: View {
    let icon: String
    let label: String
    let tint: Color
    let isActive: Bool
    let glowColor: Color
    let action: () -> Void

    @State private var bounced = false

    var body: some View {
        Button {
            triggerBounce()
            action()
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    // Frosted glass circle
                    Circle()
                        .fill(.black.opacity(0.35))
                        .frame(width: 52, height: 52)
                        .overlay(
                            Circle()
                                .stroke(
                                    isActive ? glowColor.opacity(0.45) : Color.white.opacity(0.12),
                                    lineWidth: 1.2
                                )
                        )

                    // Glow aura when active
                    if isActive {
                        Circle()
                            .fill(glowColor.opacity(0.18))
                            .frame(width: 52, height: 52)
                            .blur(radius: 6)
                    }

                    // Icon
                    Image(systemName: icon)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(tint)
                        .scaleEffect(bounced ? 1.45 : 1.0)
                        .shadow(color: isActive ? glowColor.opacity(0.6) : .clear, radius: 8)
                }
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)

                Text(label)
                    .font(.system(size: 10.5, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.72))
            }
        }
        .buttonStyle(.plain)
    }

    private func triggerBounce() {
        withAnimation(.spring(response: 0.22, dampingFraction: 0.35)) {
            bounced = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.55)) {
                bounced = false
            }
        }
    }
}

import SwiftUI

// MARK: - Video Bottom Info (Title + Description + Learn More tap)
struct VideoBottomInfo: View {
    let video: VideoData
    let onLearnMore: ((Topic) -> Void)?   // called when user taps the title and a topic exists

    @State private var isExpanded = false

    // Find a matching topic by exact title match
    private var matchedTopic: Topic? {
        allTopics.first { $0.name.lowercased() == video.title.lowercased() }
    }

    init(video: VideoData, onLearnMore: ((Topic) -> Void)? = nil) {
        self.video = video
        self.onLearnMore = onLearnMore
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {

            // ── Title row (tappable if topic exists) ────────────────────────
            HStack(alignment: .top, spacing: 6) {
                Button {
                    if let topic = matchedTopic {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        onLearnMore?(topic)
                    }
                } label: {
                    Text(video.title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(isExpanded ? nil : 2)
                        .shadow(color: .black.opacity(0.55), radius: 6, y: 2)
                        .multilineTextAlignment(.leading)
                }
                .buttonStyle(.plain)
                .disabled(matchedTopic == nil)

                // "Learn More" badge — only shows when a matching topic exists
                if matchedTopic != nil {
                    LearnMoreBadge()
                        .onTapGesture {
                            if let topic = matchedTopic {
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                onLearnMore?(topic)
                            }
                        }
                }
            }

            // ── Description ─────────────────────────────────────────────────
            if !video.description.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    Text(video.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(isExpanded ? nil : 2)
                        .shadow(color: .black.opacity(0.4), radius: 3)

                    if !isExpanded {
                        Button {
                            withAnimation(.easeInOut(duration: 0.22)) {
                                isExpanded = true
                            }
                        } label: {
                            Text("more")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        isExpanded.toggle()
                    }
                }
            }
        }
    }
}

// MARK: - Learn More Badge
struct LearnMoreBadge: View {
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "book.fill")
                .font(.system(size: 8, weight: .bold))
            Text("Learn")
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .tracking(0.5)
        }
        .foregroundColor(.black)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#FFD200"), Color(hex: "#F7971E")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        )
        .shadow(color: Color(hex: "#F7971E").opacity(0.5), radius: 6, y: 2)
        .scaleEffect(pulse ? 1.06 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

import SwiftUI

// MARK: - Topics List View
struct TopicsListView: View {
    let learningSubject: LearningSubject

    var topics: [Topic] {
        allTopics.filter { $0.subject == learningSubject.name }
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // ── Subject Hero ──────────────────────────────────────────────
                subjectHero
                    .padding(.bottom, 8)

                // ── Topic Rows ────────────────────────────────────────────────
                LazyVStack(spacing: 12) {
                    ForEach(Array(topics.enumerated()), id: \.element.id) { index, topic in
                        NavigationLink(
                            destination: TopicDetailView(
                                topic: topic,
                                subjectColor: learningSubject.color
                            )
                        ) {
                            ImprovedTopicRow(topic: topic,
                                             index: index + 1,
                                             color: learningSubject.color)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(learningSubject.name)
        .navigationBarTitleDisplayMode(.large)
        .background(Color(.systemBackground))
    }

    // MARK: - Subject hero banner
    private var subjectHero: some View {
        ZStack(alignment: .bottomLeading) {
            // Deep solid gradient — always high contrast
            LinearGradient(
                colors: [learningSubject.color, learningSubject.color.opacity(0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 110)

            // Decorative circle accent
            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 130, height: 130)
                .offset(x: 290, y: -30)

            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 80, height: 80)
                .offset(x: 230, y: 20)

            HStack(spacing: 12) {
                // Subject icon tile
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.22))
                        .frame(width: 50, height: 50)
                    Image(systemName: subjectIcon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("\(topics.count) Topics")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.white)                     // ✅ white on deep color = readable
                    Text("Tap a topic to start learning")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))       // ✅ still readable
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 18)
        }
    }

    private var subjectIcon: String {
        switch learningSubject.name {
        case "Science":     return "atom"
        case "Maths":       return "function"
        case "Programming": return "chevron.left.forwardslash.chevron.right"
        case "History":     return "book.closed"
        case "Geography":   return "globe"
        default:            return "graduationcap"
        }
    }
}

// MARK: - Improved Topic Row
struct ImprovedTopicRow: View {
    let topic: Topic
    let index: Int
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            // Index badge
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 36, height: 36)
                Text("\(index)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(topic.name)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)

                Text(topic.description.prefix(60).trimmingCharacters(in: .whitespacesAndNewlines) + "…")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                // Stats row
                HStack(spacing: 10) {
                    Label("\(topic.videos.count) videos", systemImage: "play.fill")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(color.opacity(0.8))

                    if !topic.keyConcepts.isEmpty {
                        Label("\(topic.keyConcepts.count) concepts", systemImage: "lightbulb.fill")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(uiColor: .tertiaryLabel))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Video Row for Subject (sheet player)
struct VideoRowViewSubject: View {
    let video: TopicVideo
    let subjectColor: Color
    @State private var showVideoPlayer = false

    var body: some View {
        Button {
            showVideoPlayer = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(subjectColor.opacity(0.12))
                        .frame(width: 52, height: 42)
                    Image(systemName: "play.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(subjectColor)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(video.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(video.duration)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(uiColor: .tertiaryLabel))
            }
            .padding(12)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.separator).opacity(0.25), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showVideoPlayer) {
            CourseVideoViewSubject(videoTitle: video.title, videoUrl: video.videoUrl)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Video Sheet Player
struct CourseVideoViewSubject: View {
    let videoTitle: String
    let videoUrl: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let videoID = extractYouTubeID(from: videoUrl) {
                    LearningYouTubeVideoPlayer(videoID: videoID)
                        .frame(height: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
                        .padding(.horizontal, 16)
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemGray5))
                        .frame(height: 240)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "video.slash.fill")
                                    .font(.title)
                                    .foregroundColor(.secondary)
                                Text("Video unavailable")
                                    .foregroundColor(.secondary)
                            }
                        )
                        .padding(.horizontal, 16)
                }

                Spacer()
            }
            .padding(.top, 16)
            .navigationTitle(videoTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func extractYouTubeID(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        if url.host?.contains("youtu.be") == true { return url.lastPathComponent }
        if url.host?.contains("youtube.com") == true {
            return URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "v" })?.value
        }
        // If it's already just an ID (no dots)
        if !urlString.contains(".") { return urlString }
        return nil
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Preview
struct TopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TopicsListView(
                learningSubject: LearningSubject(id: 1, name: "Science", color: .green)
            )
        }
    }
}

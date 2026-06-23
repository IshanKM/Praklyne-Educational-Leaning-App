import SwiftUI

// MARK: - Liked & Saved Tab View
struct LikedSavedView: View {
    @StateObject private var library = VideoLibraryStore.shared
    @StateObject private var service  = VideoService()

    @State private var selectedSection = 0   // 0 = Liked, 1 = Saved
    @Namespace private var segmentNamespace

    // Resolve full VideoData objects from stored titles
    private var likedVideos: [VideoData] {
        service.shortVideos.filter { library.likedTitles.contains($0.title) }
    }
    private var savedVideos: [VideoData] {
        service.shortVideos.filter { library.savedTitles.contains($0.title) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // ── Header ───────────────────────────────────────────────────
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("My Library")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            Text("Your liked & saved videos")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        // Total badge
                        let total = library.likedTitles.count + library.savedTitles.count
                        if total > 0 {
                            Text("\(total) videos")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.accentColor)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)

                    // ── Segment control ──────────────────────────────────────
                    HStack(spacing: 0) {
                        segmentButton(title: "❤️  Liked", index: 0, count: library.likedTitles.count)
                        segmentButton(title: "🔖  Saved", index: 1, count: library.savedTitles.count)
                    }
                    .padding(4)
                    .background(Color(.systemFill))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .padding(.horizontal, 20)
                }
                .padding(.top, 16)
                .padding(.bottom, 12)
                .background(Color(.systemBackground))

                Divider()

                // ── Content ──────────────────────────────────────────────────
                ScrollView(showsIndicators: false) {
                    if service.shortVideos.isEmpty {
                        loadingState
                    } else {
                        let videos = selectedSection == 0 ? likedVideos : savedVideos
                        if videos.isEmpty {
                            emptyState(for: selectedSection)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(videos) { video in
                                    SavedVideoRow(
                                        video: video,
                                        isLiked: library.isLiked(video),
                                        isSaved: library.isSaved(video),
                                        onRemove: {
                                            withAnimation(.spring(response: 0.35)) {
                                                if selectedSection == 0 {
                                                    library.removeLiked(title: video.title)
                                                } else {
                                                    library.removeSaved(title: video.title)
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                            .padding(.bottom, 100)
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: selectedSection)
            }
            .navigationBarHidden(true)
        }
        .onAppear { service.fetchShortVideos() }
    }

    // MARK: - Segment Button
    @ViewBuilder
    private func segmentButton(title: String, index: Int, count: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedSection = index
            }
        } label: {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(selectedSection == index ? Color.white.opacity(0.3) : Color(.systemFill))
                        .clipShape(Capsule())
                }
            }
            .foregroundColor(selectedSection == index ? .white : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background {
                if selectedSection == index {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .matchedGeometryEffect(id: "segment", in: segmentNamespace)
                        .shadow(color: Color(hex: "#1A73E8").opacity(0.35), radius: 6, y: 2)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Loading
    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.3)
            Text("Loading your library…")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    // MARK: - Empty State
    @ViewBuilder
    private func emptyState(for section: Int) -> some View {
        let isLiked = section == 0
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color(.systemFill))
                    .frame(width: 100, height: 100)
                Image(systemName: isLiked ? "heart.slash.fill" : "bookmark.slash.fill")
                    .font(.system(size: 38, weight: .light))
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)

            VStack(spacing: 8) {
                Text(isLiked ? "No Liked Videos Yet" : "No Saved Videos Yet")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(isLiked
                     ? "Tap ❤️ on any short video to like it.\nThey'll appear here."
                     : "Tap 🔖 on any short video to save it.\nThey'll appear here.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Saved Video Row
struct SavedVideoRow: View {
    let video: VideoData
    let isLiked: Bool
    let isSaved: Bool
    let onRemove: () -> Void

    @State private var showPlayer = false

    var body: some View {
        HStack(spacing: 14) {
            // Thumbnail placeholder with play icon
            Button { showPlayer = true } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#1A73E8").opacity(0.75), Color(hex: "#6C63FF").opacity(0.75)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 54)
                    Image(systemName: "play.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 8) {
                    // Category badge
                    Text(video.category)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(hex: "#1A73E8"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(hex: "#1A73E8").opacity(0.1))
                        .clipShape(Capsule())

                    // Status icons
                    if isLiked {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                    }
                    if isSaved {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(red: 0.25, green: 0.82, blue: 0.5))
                    }
                }
            }

            Spacer()

            // Remove button
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(.systemFill), Color(.tertiaryLabel))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .sheet(isPresented: $showPlayer) {
            SavedVideoPlayerSheet(video: video)
        }
    }
}

// MARK: - Saved Video Player Sheet
struct SavedVideoPlayerSheet: View {
    let video: VideoData
    @Environment(\.dismiss) private var dismiss

    private var videoID: String {
        let link = video.youtubeLink
        if let r = link.range(of: "v=") {
            return String(link[r.upperBound...].prefix(while: { $0 != "&" }))
        }
        if link.contains("youtu.be/"), let url = URL(string: link) {
            return url.lastPathComponent
        }
        return link
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                LearningYouTubeVideoPlayer(videoID: videoID)
                    .frame(height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.15), radius: 12, y: 4)
                    .padding(.horizontal, 16)

                // Info card
                VStack(alignment: .leading, spacing: 10) {
                    Text(video.title)
                        .font(.system(size: 17, weight: .bold))
                    if !video.description.isEmpty {
                        Text(video.description)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    Text(video.category)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#1A73E8"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(hex: "#1A73E8").opacity(0.1))
                        .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .padding(.horizontal, 16)

                Spacer()
            }
            .padding(.top, 16)
            .navigationTitle(video.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

import SwiftUI

// MARK: - Main Shorts View
struct VideoShortsView: View {
    @StateObject private var service = VideoService()
    @StateObject private var library = VideoLibraryStore.shared  // ← persistent store
    @State private var currentIndex = 0
    @State private var isMuted = false
    @State private var dragOffset: CGFloat = 0
    @State private var isTransitioning = false
    @State private var shareItem: ShareItem?
    @State private var learnTopic: Topic?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if service.shortVideos.isEmpty {
                ShortsLoadingView()
            } else {
                let video = service.shortVideos[currentIndex]
                let vid = extractVideoID(from: video.youtubeLink)

                // ── Layer 1: Full-screen video ──────────────────
                YouTubePlayerVideoView(videoID: vid, isMuted: isMuted)
                    .id(currentIndex) // Force fresh WebView on every switch
                    .ignoresSafeArea()
                    .offset(y: dragOffset)
                    .opacity(isTransitioning ? 0 : 1)
                    .animation(.easeInOut(duration: 0.18), value: isTransitioning)
                    .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.75), value: dragOffset)

                // ── Layer 2: Gradient vignettes ─────────────────
                gradientOverlays

                // ── Layer 3: UI chrome ──────────────────────────
                VStack(spacing: 0) {
                    topBar(video: video)
                    Spacer()
                    bottomRow(video: video, vid: vid)
                }
                .ignoresSafeArea(edges: .top)
            }
        }
        .gesture(swipeGesture)
        .onAppear {
            service.fetchShortVideos(onComplete: {
                // Shuffle once after fetch so order is always different
                service.shortVideos.shuffle()
            })
        }
        .sheet(item: $shareItem) { item in
            ActivityView(items: [item.url])
        }
        .sheet(item: $learnTopic) { topic in
            NavigationView {
                TopicDetailView(
                    topic: topic,
                    subjectColor: subjectColor(for: topic.subject)
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") { learnTopic = nil }
                    }
                }
            }
        }
    }

    // MARK: - Gradient Overlays
    private var gradientOverlays: some View {
        ZStack {
            // Top vignette — status bar readability
            LinearGradient(
                colors: [.black.opacity(0.72), .black.opacity(0.3), .clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 220)
            .frame(maxHeight: .infinity, alignment: .top)
            .ignoresSafeArea(edges: .top)

            // Bottom vignette — overlay text readability
            LinearGradient(
                colors: [.clear, .black.opacity(0.55), .black.opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 340)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
        }
    }

    // MARK: - Top Bar
    @ViewBuilder
    private func topBar(video: VideoData) -> some View {
        HStack(spacing: 10) {
            // Category badge
            HStack(spacing: 5) {
                Image(systemName: "sparkles")
                    .font(.system(size: 9, weight: .bold))
                Text(video.category.uppercased())
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .tracking(0.8)
            }
            .foregroundColor(.black)
            .padding(.horizontal, 13)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.25, green: 0.92, blue: 0.6),
                                Color(red: 0.1, green: 0.75, blue: 0.5)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: Color(red: 0.1, green: 0.75, blue: 0.5).opacity(0.5), radius: 10, y: 5)

            Spacer()

            // Progress counter
            if !service.shortVideos.isEmpty {
                Text("\(currentIndex + 1)  /  \(service.shortVideos.count)")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 11)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.35))
                    .clipShape(Capsule())
            }

            // Mute toggle
            Button {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.6)) {
                    isMuted.toggle()
                }
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } label: {
                ZStack {
                    Circle()
                        .fill(.black.opacity(0.4))
                        .frame(width: 40, height: 40)
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(isMuted ? .white.opacity(0.5) : .white)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 18)
        .padding(.top, 56)   // below status bar / Dynamic Island
        .padding(.bottom, 10)
    }

    // MARK: - Bottom Row (info + action buttons)
    @ViewBuilder
    private func bottomRow(video: VideoData, vid: String) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Left: title + description
            VideoBottomInfo(video: video, onLearnMore: { topic in
                learnTopic = topic
            })
            .padding(.bottom, 88)
            .padding(.leading, 18)
            .frame(maxWidth: .infinity, alignment: .leading)

            // Right: action sidebar
            VideoActionSidebar(
                video: video,
                isLiked: library.isLiked(video),
                isSaved: library.isSaved(video),
                onLike: {
                    library.toggleLike(video)
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                },
                onSave: {
                    library.toggleSave(video)
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                },
                onShare: {
                    if let url = URL(string: "https://www.youtube.com/watch?v=\(vid)") {
                        shareItem = ShareItem(url: url)
                    }
                }
            )
            .padding(.bottom, 96)
            .padding(.trailing, 14)
        }
    }

    // MARK: - Swipe Gesture
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 18)
            .onChanged { val in
                guard !isTransitioning else { return }
                let dy = val.translation.height
                let canGoNext = dy < 0 && currentIndex < service.shortVideos.count - 1
                let canGoPrev = dy > 0 && currentIndex > 0
                if canGoNext || canGoPrev {
                    dragOffset = dy * 0.2  // rubberband resistance
                }
            }
            .onEnded { val in
                guard !isTransitioning else { return }
                let dy = val.translation.height
                if dy < -55 {
                    navigateTo(currentIndex + 1)
                } else if dy > 55 {
                    navigateTo(currentIndex - 1)
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) {
                        dragOffset = 0
                    }
                }
            }
    }

    // MARK: - Navigation
    private func navigateTo(_ index: Int) {
        guard index >= 0,
              index < service.shortVideos.count,
              !isTransitioning else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.82)) { dragOffset = 0 }
            return
        }

        withAnimation(.easeIn(duration: 0.13)) { isTransitioning = true }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
            currentIndex = index
            dragOffset = 0
            withAnimation(.easeOut(duration: 0.13)) { isTransitioning = false }
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }

    // MARK: - Actions (now delegated to VideoLibraryStore)

    // MARK: - Helpers
    private func extractVideoID(from link: String) -> String {
        if let range = link.range(of: "v=") {
            let rest = String(link[range.upperBound...])
            return String(rest.prefix(while: { $0 != "&" && $0 != " " }))
        }
        if link.contains("youtu.be/"), let url = URL(string: link) {
            return url.lastPathComponent
        }
        return link // already an ID
    }

    private func subjectColor(for subject: String) -> Color {
        switch subject {
        case "Science":     return .green
        case "Maths":       return .blue
        case "Programming": return .pink
        case "History":     return .orange
        case "Geography":   return .teal
        default:            return .blue
        }
    }
}

// MARK: - Animated Loading View
struct ShortsLoadingView: View {
    @State private var pulse = false
    @State private var rotate = 0.0
    @State private var dotScale: [CGFloat] = [1, 1, 1]
    private let accent = Color(red: 0.25, green: 0.92, blue: 0.6)

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 32) {
                // Orbiting ring + icon
                ZStack {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        accent.opacity(0.7 - Double(i) * 0.18),
                                        Color(red: 0.1, green: 0.55, blue: 0.9).opacity(0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 1.5 - CGFloat(i) * 0.3, dash: [4, 6])
                            )
                            .frame(
                                width: CGFloat(68 + i * 22),
                                height: CGFloat(68 + i * 22)
                            )
                            .rotationEffect(.degrees(rotate + Double(i) * 40))
                    }

                    Image(systemName: "play.rectangle.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [accent, Color(red: 0.1, green: 0.55, blue: 0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(pulse ? 1.1 : 0.95)
                }
                .onAppear {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        rotate = 360
                    }
                    withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                        pulse = true
                    }
                }

                // Text + bouncing dots
                VStack(spacing: 10) {
                    Text("Loading Shorts")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    HStack(spacing: 7) {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .fill(accent.opacity(0.75))
                                .frame(width: 6, height: 6)
                                .scaleEffect(dotScale[i])
                                .onAppear {
                                    withAnimation(
                                        .easeInOut(duration: 0.55)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(i) * 0.18)
                                    ) {
                                        dotScale[i] = 1.7
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Share Item Wrapper
struct ShareItem: Identifiable {
    let id = UUID()
    let url: URL
}

// MARK: - System Share Sheet
struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popover = controller.popoverPresentationController {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                popover.sourceView = rootVC.view
                popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
        }
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

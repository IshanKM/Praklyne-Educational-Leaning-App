import SwiftUI

// MARK: - Language enum
enum LearningLanguage: String, CaseIterable {
    case english = "EN"
    case sinhala = "සිං"
}

// MARK: - Topic Detail View
struct TopicDetailView: View {
    let topic: Topic
    let subjectColor: Color

    @State private var language: LearningLanguage = .english
    @State private var showFullSummary = false
    @Namespace private var langNamespace

    // Localised accessors
    private var displayName: String {
        language == .sinhala && !topic.sinhaleName.isEmpty ? topic.sinhaleName : topic.name
    }
    private var displayDescription: String {
        language == .sinhala && !topic.sinhalaDescription.isEmpty ? topic.sinhalaDescription : topic.description
    }
    private var displayKeyConcepts: [String] {
        language == .sinhala && !topic.sinhalaKeyConcepts.isEmpty ? topic.sinhalaKeyConcepts : topic.keyConcepts
    }
    private var displaySummary: String {
        language == .sinhala && !topic.sinhalaSummary.isEmpty ? topic.sinhalaSummary : topic.summary
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                // ── Hero Header ──────────────────────────────────────────────
                heroHeader

                VStack(spacing: 28) {

                    // ── Overview ─────────────────────────────────────────────
                    if !displayDescription.isEmpty {
                        sectionCard(title: "Overview", icon: "text.alignleft") {
                            Text(displayDescription)
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                                .lineSpacing(5)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }

                    // ── Key Concepts ─────────────────────────────────────────
                    if !displayKeyConcepts.isEmpty {
                        sectionCard(title: "Key Concepts", icon: "lightbulb.fill") {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(Array(displayKeyConcepts.enumerated()), id: \.offset) { _, concept in
                                    HStack(alignment: .top, spacing: 10) {
                                        Circle()
                                            .fill(subjectColor)
                                            .frame(width: 7, height: 7)
                                            .padding(.top, 5)
                                        Text(concept)
                                            .font(.system(size: 14))
                                            .foregroundColor(.primary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }

                    // ── Videos ───────────────────────────────────────────────
                    if !topic.videos.isEmpty {
                        sectionCard(title: "Videos", icon: "play.circle.fill") {
                            VStack(spacing: 10) {
                                ForEach(topic.videos) { video in
                                    VideoRowViewSubject(video: video, subjectColor: subjectColor)
                                }
                            }
                        }
                    }

                    // ── Diagrams ─────────────────────────────────────────────
                    if !topic.diagramImageURLs.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            sectionLabel(title: "Diagrams", icon: "photo.stack")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(topic.diagramImageURLs, id: \.self) { urlString in
                                        DiagramImageCard(urlString: urlString)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // ── Fun Facts ────────────────────────────────────────────
                    if !topic.funFacts.isEmpty {
                        sectionCard(title: "Did You Know? 💡", icon: "star.fill") {
                            VStack(spacing: 12) {
                                ForEach(Array(topic.funFacts.enumerated()), id: \.offset) { index, fact in
                                    FunFactCard(index: index + 1, fact: fact, color: subjectColor)
                                }
                            }
                        }
                    }

                    // ── Resources ────────────────────────────────────────────
                    if !topic.resources.isEmpty {
                        sectionCard(title: "Resources & Links", icon: "link") {
                            VStack(spacing: 10) {
                                ForEach(topic.resources) { resource in
                                    ResourceRow(resource: resource, color: subjectColor)
                                }
                            }
                        }
                    }

                    // ── Summary ──────────────────────────────────────────────
                    if !displaySummary.isEmpty {
                        SummaryCard(summary: displaySummary, color: subjectColor,
                                    showFull: $showFullSummary)
                            .padding(.horizontal, 20)
                    }

                    // ── Related Topics ───────────────────────────────────────
                    if !topic.relatedTopicIds.isEmpty {
                        let related = allTopics.filter { topic.relatedTopicIds.contains($0.id) }
                        if !related.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                sectionLabel(title: "Related Topics", icon: "arrow.triangle.2.circlepath")
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(related) { relTopic in
                                            RelatedTopicCard(topic: relTopic, subjectColor: subjectColor)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 24)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Hero Header
    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Deep solid background — always readable
            LinearGradient(
                colors: [subjectColor, subjectColor.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 240)

            // Dark scrim at the bottom so white text stays legible
            LinearGradient(
                colors: [.clear, .black.opacity(0.35)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 240)

            // Decorative blobs (subtle on solid bg)
            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 180, height: 180)
                .offset(x: 220, y: -60)
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 100, height: 100)
                .offset(x: -30, y: -20)

            VStack(alignment: .leading, spacing: 12) {
                // Subject badge — white background chip for high contrast
                HStack(spacing: 6) {
                    Image(systemName: subjectIcon)
                        .font(.system(size: 11, weight: .bold))
                    Text(topic.subject.uppercased())
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(1)
                }
                .foregroundColor(subjectColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white)          // ✅ solid white = fully opaque
                .clipShape(Capsule())

                // Topic name — white on deep colour = ✅ WCAG AA compliant
                Text(displayName)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 4, y: 2)
                    .fixedSize(horizontal: false, vertical: true)

                // Language toggle
                languageToggle
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
    }

    // MARK: - Language Toggle
    private var languageToggle: some View {
        HStack(spacing: 0) {
            ForEach(LearningLanguage.allCases, id: \.self) { lang in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        language = lang
                    }
                } label: {
                    Text(lang.rawValue)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(language == lang ? subjectColor : .white.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background {
                            if language == lang {
                                Capsule()
                                    .fill(.white)
                                    .matchedGeometryEffect(id: "lang", in: langNamespace)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(.white.opacity(0.22))
        .clipShape(Capsule())
    }

    // MARK: - Section Card helper
    @ViewBuilder
    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionLabel(title: title, icon: icon)
            content()
        }
        .padding(18)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(.separator).opacity(0.35), lineWidth: 0.5)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Section label helper
    @ViewBuilder
    private func sectionLabel(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(subjectColor)
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, title == "Diagrams" || title == "Related Topics" ? 20 : 0)
    }

    // MARK: - Subject icon helper
    private var subjectIcon: String {
        switch topic.subject {
        case "Science":     return "atom"
        case "Maths":       return "function"
        case "Programming": return "chevron.left.forwardslash.chevron.right"
        case "History":     return "book.closed"
        case "Geography":   return "globe"
        default:            return "graduationcap"
        }
    }
}

// MARK: - Fun Fact Card
struct FunFactCard: View {
    let index: Int
    let fact: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 32, height: 32)
                Text("\(index)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
            }
            Text(fact)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(14)
        .background(color.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Resource Row
struct ResourceRow: View {
    let resource: LearningResource
    let color: Color

    var body: some View {
        Button {
            if let url = URL(string: resource.url) {
                UIApplication.shared.open(url)
            }
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(color.opacity(0.12))
                        .frame(width: 38, height: 38)
                    Image(systemName: "safari.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(resource.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(resource.source)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.up.right.square")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(12)
            .background(Color(.tertiarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Summary Card
struct SummaryCard: View {
    let summary: String
    let color: Color
    @Binding var showFull: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color)
                Text("Key Takeaways")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }

            Text(summary)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .lineSpacing(4)
                .lineLimit(showFull ? nil : 3)
                .fixedSize(horizontal: false, vertical: true)
                .animation(.easeInOut(duration: 0.25), value: showFull)

            Button {
                withAnimation(.easeInOut(duration: 0.25)) { showFull.toggle() }
            } label: {
                HStack(spacing: 4) {
                    Text(showFull ? "Show Less" : "Read More")
                        .font(.system(size: 13, weight: .semibold))
                    Image(systemName: showFull ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(color)
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [color.opacity(0.12), color.opacity(0.04)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Custom Async Image (Bypasses Wikipedia 403 blocks)
enum CustomAsyncImagePhase {
    case empty
    case success(Image)
    case failure(Error)
}

struct CustomAsyncImage<Content: View>: View {
    let url: URL?
    @ViewBuilder let content: (CustomAsyncImagePhase) -> Content

    @State private var phase: CustomAsyncImagePhase = .empty

    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }

    private func loadImage() async {
        guard let url = url else {
            phase = .failure(URLError(.badURL))
            return
        }
        phase = .empty

        var request = URLRequest(url: url)
        // Add educational User-Agent header to satisfy Wikipedia Commons server security policies
        request.setValue("PraklyneLearningApp/1.0 (contact@praklyne.edu; educational demo)", forHTTPHeaderField: "User-Agent")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                phase = .failure(URLError(.badServerResponse))
                return
            }
            if let uiImage = UIImage(data: data) {
                phase = .success(Image(uiImage: uiImage))
            } else {
                phase = .failure(URLError(.cannotDecodeContentData))
            }
        } catch {
            phase = .failure(error)
        }
    }
}

// MARK: - Diagram Image Card
struct DiagramImageCard: View {
    let urlString: String

    var body: some View {
        CustomAsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray5))
                    .overlay(ProgressView().tint(.secondary))
                    .frame(width: 180, height: 130)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: .black.opacity(0.1), radius: 6, y: 3)
            case .failure:
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemGray5))
                    .frame(width: 180, height: 130)
                    .overlay(
                        Image(systemName: "photo.badge.exclamationmark")
                            .foregroundColor(.secondary)
                    )
            }
        }
        .frame(width: 180, height: 130)
    }
}

// MARK: - Related Topic Card
struct RelatedTopicCard: View {
    let topic: Topic
    let subjectColor: Color

    private var cardColor: Color {
        switch topic.subject {
        case "Science":     return .green
        case "Maths":       return .blue
        case "Programming": return .pink
        case "History":     return .orange
        case "Geography":   return .teal
        default:            return subjectColor
        }
    }

    var body: some View {
        NavigationLink(
            destination: TopicDetailView(topic: topic, subjectColor: cardColor)
        ) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(cardColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(cardColor)
                }

                Text(topic.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(topic.subject)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(width: 130)
            .padding(14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

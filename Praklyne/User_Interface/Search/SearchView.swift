import SwiftUI

// MARK: - Search Result types
enum SearchResultType: String {
    case topic    = "Topic"
    case video    = "Video"
    case subject  = "Subject"
}

struct SearchResult: Identifiable {
    let id = UUID()
    let type: SearchResultType
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    // Payloads — only one will be set
    let topic: Topic?
    let video: VideoData?
    let subject: Subject?
}

// MARK: - Active Filter
enum SearchFilter: String, CaseIterable {
    case all      = "All"
    case topics   = "Topics"
    case videos   = "Videos"
    case subjects = "Subjects"

    var icon: String {
        switch self {
        case .all:      return "magnifyingglass"
        case .topics:   return "book.fill"
        case .videos:   return "play.circle.fill"
        case .subjects: return "square.grid.2x2.fill"
        }
    }
}

// MARK: - Main Search View
struct SearchView: View {
    @StateObject private var service = VideoService()
    @State private var query = ""
    @State private var activeFilter: SearchFilter = .all
    @State private var recentSearches: [String] = []
    @State private var isFocused = false

    // Navigation destinations
    @State private var selectedTopic: Topic?
    @State private var selectedVideo: VideoData?

    @Namespace private var filterNamespace

    private let subjects: [Subject] = [
        Subject(id: 1, name: "Science",     color: .green,  icon: "atom"),
        Subject(id: 2, name: "Maths",       color: .blue,   icon: "function"),
        Subject(id: 3, name: "Programming", color: .pink,   icon: "chevron.left.forwardslash.chevron.right"),
        Subject(id: 4, name: "Business",    color: .purple, icon: "briefcase.fill"),
        Subject(id: 5, name: "History",     color: .orange, icon: "book.closed"),
        Subject(id: 6, name: "Geography",   color: .teal,   icon: "globe")
    ]

    // MARK: – Computed results
    private var allResults: [SearchResult] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }
        let q = query.lowercased()
        var results: [SearchResult] = []

        // Subjects
        for subj in subjects where subj.name.lowercased().contains(q) {
            results.append(SearchResult(
                type: .subject, title: subj.name,
                subtitle: "\(allTopics.filter { $0.subject == subj.name }.count) Topics",
                icon: subj.icon, color: subj.color,
                topic: nil, video: nil, subject: subj
            ))
        }

        // Topics
        for topic in allTopics
            where topic.name.lowercased().contains(q)
               || topic.description.lowercased().contains(q)
               || topic.keyConcepts.joined(separator: " ").lowercased().contains(q) {
            results.append(SearchResult(
                type: .topic, title: topic.name,
                subtitle: topic.subject + " · \(topic.videos.count) videos",
                icon: "book.fill", color: subjectColor(for: topic.subject),
                topic: topic, video: nil, subject: nil
            ))
        }

        // Videos
        for video in service.shortVideos
            where video.title.lowercased().contains(q)
               || video.category.lowercased().contains(q)
               || video.description.lowercased().contains(q) {
            results.append(SearchResult(
                type: .video, title: video.title,
                subtitle: video.category,
                icon: "play.circle.fill", color: Color(hex: "#1A73E8"),
                topic: nil, video: video, subject: nil
            ))
        }

        return results
    }

    private var filteredResults: [SearchResult] {
        switch activeFilter {
        case .all:      return allResults
        case .topics:   return allResults.filter { $0.type == .topic }
        case .videos:   return allResults.filter { $0.type == .video }
        case .subjects: return allResults.filter { $0.type == .subject }
        }
    }

    // Group by type for "All" display
    private var groupedResults: [(title: String, items: [SearchResult])] {
        if activeFilter != .all { return [("Results", filteredResults)] }
        var groups: [(title: String, items: [SearchResult])] = []
        let subjects = filteredResults.filter { $0.type == .subject }
        let topics   = filteredResults.filter { $0.type == .topic }
        let videos   = filteredResults.filter { $0.type == .video }
        if !subjects.isEmpty { groups.append(("Subjects", subjects)) }
        if !topics.isEmpty   { groups.append(("Topics", topics)) }
        if !videos.isEmpty   { groups.append(("Videos", videos)) }
        return groups
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                // ── Header ─────────────────────────────────────────────────
                searchHeader

                // ── Filter pills ───────────────────────────────────────────
                if !query.isEmpty {
                    filterBar
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                // ── Content ────────────────────────────────────────────────
                ZStack {
                    if query.isEmpty {
                        emptyQueryView
                            .transition(.opacity)
                    } else if filteredResults.isEmpty {
                        noResultsView
                            .transition(.opacity)
                    } else {
                        resultsView
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: query.isEmpty)
                .animation(.easeInOut(duration: 0.15), value: filteredResults.count)
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .sheet(item: $selectedTopic) { topic in
            NavigationView {
                TopicDetailView(topic: topic, subjectColor: subjectColor(for: topic.subject))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") { selectedTopic = nil }
                        }
                    }
            }
        }
        .sheet(item: $selectedVideo) { video in
            SavedVideoPlayerSheet(video: video)
        }
        .onAppear { service.fetchShortVideos() }
    }

    // MARK: – Search Header
    private var searchHeader: some View {
        VStack(spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Search")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Topics, videos, subjects")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 20)

            // Search field
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(query.isEmpty ? .secondary : Color(hex: "#1A73E8"))

                TextField("Search topics, videos, subjects…", text: $query)
                    .font(.system(size: 16))
                    .submitLabel(.search)
                    .onSubmit { saveRecentSearch() }

                if !query.isEmpty {
                    Button {
                        withAnimation { query = "" }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(query.isEmpty ? Color.clear : Color(hex: "#1A73E8").opacity(0.4), lineWidth: 1.5)
            )
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(Color(.systemBackground))
    }

    // MARK: – Filter Bar
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SearchFilter.allCases, id: \.self) { filter in
                    let count: Int = {
                        switch filter {
                        case .all:      return allResults.count
                        case .topics:   return allResults.filter { $0.type == .topic }.count
                        case .videos:   return allResults.filter { $0.type == .video }.count
                        case .subjects: return allResults.filter { $0.type == .subject }.count
                        }
                    }()
                    SearchFilterChip(
                        filter: filter,
                        isActive: activeFilter == filter,
                        count: count,
                        namespace: filterNamespace
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            activeFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }

    // MARK: – Empty Query (recent searches + subject chips)
    private var emptyQueryView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                // Recent searches
                if !recentSearches.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Recent Searches", systemImage: "clock")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                            Spacer()
                            Button("Clear") {
                                withAnimation { recentSearches = [] }
                                UserDefaults.standard.removeObject(forKey: "search.recents")
                            }
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#1A73E8"))
                        }

                        ForEach(recentSearches.prefix(5), id: \.self) { term in
                            Button {
                                query = term
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                    Text(term)
                                        .font(.system(size: 15))
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "arrow.up.left")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 10)
                                Divider()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Browse by subject
                VStack(alignment: .leading, spacing: 14) {
                    Label("Browse Subjects", systemImage: "square.grid.2x2.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)

                    LazyVGrid(
                        columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                        spacing: 12
                    ) {
                        ForEach(subjects, id: \.id) { subject in
                            SubjectSearchChip(subject: subject) {
                                query = subject.name
                            }
                        }
                    }
                }

                // Popular topic searches
                VStack(alignment: .leading, spacing: 12) {
                    Label("Popular Topics", systemImage: "flame.fill")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)

                    FlowLayout(tags: ["Electricity", "Air Pressure", "Gravitation", "Algebra", "Swift Basics", "Calculus", "World War II", "Thermodynamics"]) { tag in
                        query = tag
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }

    // MARK: – No Results
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 52, weight: .light))
                .foregroundColor(.secondary)
                .padding(.top, 60)
            Text("No results for \"\(query)\"")
                .font(.system(size: 17, weight: .semibold))
            Text("Try a different keyword or browse subjects below.")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: – Results
    private var resultsView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(groupedResults, id: \.title) { group in
                    if groupedResults.count > 1 {
                        Text(group.title)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 8)
                    }
                    ForEach(group.items) { result in
                        SearchResultRow(result: result) {
                            saveRecentSearch()
                            handleTap(result)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                    }
                }
            }
            .padding(.bottom, 100)
            .padding(.top, 8)
        }
    }

    // MARK: – Helpers
    private func handleTap(_ result: SearchResult) {
        switch result.type {
        case .topic:
            selectedTopic = result.topic
        case .video:
            selectedVideo = result.video
        case .subject:
            if let subj = result.subject {
                selectedTopic = nil
                query = subj.name
                activeFilter = .topics
            }
        }
    }

    private func saveRecentSearch() {
        let term = query.trimmingCharacters(in: .whitespaces)
        guard !term.isEmpty else { return }
        var recents = UserDefaults.standard.stringArray(forKey: "search.recents") ?? []
        recents.removeAll { $0 == term }
        recents.insert(term, at: 0)
        recents = Array(recents.prefix(10))
        UserDefaults.standard.set(recents, forKey: "search.recents")
        recentSearches = recents
    }

    private func subjectColor(for subject: String) -> Color {
        switch subject {
        case "Science":     return .green
        case "Maths":       return .blue
        case "Programming": return .pink
        case "History":     return .orange
        case "Geography":   return .teal
        default:            return .purple
        }
    }

    // Load recents when view appears
    func loadRecents() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "search.recents") ?? []
    }
}

// MARK: - Search Filter Chip
struct SearchFilterChip: View {
    let filter: SearchFilter
    let isActive: Bool
    let count: Int
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: filter.icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(filter.rawValue)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(isActive ? Color.white.opacity(0.25) : Color(.systemFill))
                        .clipShape(Capsule())
                }
            }
            .foregroundColor(isActive ? .white : .secondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background {
                if isActive {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .matchedGeometryEffect(id: "filter", in: namespace)
                        .shadow(color: Color(hex: "#1A73E8").opacity(0.4), radius: 6, y: 2)
                } else {
                    Capsule().fill(Color(.secondarySystemBackground))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Search Result Row
struct SearchResultRow: View {
    let result: SearchResult
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                // Icon tile
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(result.color.opacity(0.13))
                        .frame(width: 44, height: 44)
                    Image(systemName: result.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(result.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(result.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        // Type badge
                        Text(result.type.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(result.color)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 2)
                            .background(result.color.opacity(0.1))
                            .clipShape(Capsule())
                        Text(result.subtitle)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Subject Search Chip (browse grid)
struct SubjectSearchChip: View {
    let subject: Subject
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(subject.color.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: subject.icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(subject.color)
                }
                Text(subject.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11))
                    .foregroundColor(Color(.tertiaryLabel))
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Flow Layout (tag cloud for popular topics)
struct FlowLayout: View {
    let tags: [String]
    let onTap: (String) -> Void

    var body: some View {
        // Simple wrapping using GeometryReader + fixed approach
        var rows: [[String]] = [[]]
        var currentRowWidth: CGFloat = 0
        let maxWidth: CGFloat = UIScreen.main.bounds.width - 40
        let tagWidth: CGFloat = 120   // approximate

        for tag in tags {
            if currentRowWidth + tagWidth > maxWidth {
                rows.append([tag])
                currentRowWidth = tagWidth
            } else {
                rows[rows.count - 1].append(tag)
                currentRowWidth += tagWidth + 8
            }
        }

        return VStack(alignment: .leading, spacing: 8) {
            ForEach(rows.indices, id: \.self) { rowIdx in
                HStack(spacing: 8) {
                    ForEach(rows[rowIdx], id: \.self) { tag in
                        Button {
                            onTap(tag)
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 11))
                                Text(tag)
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(Color(hex: "#1A73E8"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(Color(hex: "#1A73E8").opacity(0.1))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

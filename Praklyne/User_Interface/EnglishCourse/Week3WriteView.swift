import SwiftUI

// MARK: - Week 3: Write Ideas in Your Own Words

struct Week3WriteView: View {
    @ObservedObject var dataStore: CourseDataStore
    @Environment(\.dismiss) private var dismiss

    @State private var writings: [String: String] = [:]
    @State private var todayText: String = ""
    @State private var isSaved: Bool = false
    @State private var showHistory: Bool = false
    @State private var showTips: Bool = false

    private let writingTips = [
        "Use your own words — don't copy from what you saw.",
        "Write in complete sentences.",
        "Try to use new vocabulary words you learned.",
        "It's okay to make grammar mistakes — focus on expressing ideas.",
        "Aim for at least 100 words."
    ]

    private var todayKey: String {
        "week3_day_\(dataStore.totalDaysCompleted)"
    }

    private var currentDayInWeek: Int {
        (dataStore.totalDaysCompleted % 7) + 1
    }

    private var wc: Int {
        todayText.split { $0.isWhitespace }.filter { !$0.isEmpty }.count
    }

    private var wcColor: Color {
        switch wc {
        case ..<30:  return .secondary
        case 30..<70: return .orange
        default:     return .green
        }
    }

    private var wcMessage: String {
        switch wc {
        case ..<30:  return "Keep going!"
        case 30..<70: return "Good progress 👍"
        case 70..<100: return "Almost there!"
        default:      return "Excellent writing! 🎉"
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    weekHeader
                    instructionCard
                    writingSection
                    wordCountMeter
                    saveButton

                    if !writings.isEmpty {
                        pastWritingsSection
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Week 3 · Write")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { withAnimation { showTips.toggle() } }) {
                        Image(systemName: "lightbulb")
                    }
                }
            }
            .onAppear { loadData() }
        }
    }

    // MARK: - Sub-views

    private var weekHeader: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 52, height: 52)
                    Text("📝")
                        .font(.title2)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Week 3 — Write")
                        .font(.title2).fontWeight(.bold)
                    Text("Day \(currentDayInWeek) of 7")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { i in
                    Circle()
                        .fill(i < currentDayInWeek - 1 ? Color.orange :
                              i == currentDayInWeek - 1 ? Color.red : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
                Spacer()
                Text("\(dataStore.weeklyProgress[2].filter { $0 }.count)/7 days done")
                    .font(.caption).fontWeight(.semibold).foregroundColor(.orange)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.orange.opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.orange.opacity(0.2), lineWidth: 1))
        )
    }

    private var instructionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("This Week's Challenge", systemImage: "pencil.and.outline")
                .font(.headline).fontWeight(.semibold)

            Text("Write about what you learned from the documentary videos — **in your own words**. Summarise the key ideas, share your opinion, or describe what you found most interesting.")
                .font(.subheadline).foregroundColor(.secondary)

            if showTips {
                Divider()
                Text("Writing Tips")
                    .font(.subheadline).fontWeight(.semibold)
                ForEach(writingTips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.orange).font(.caption)
                        Text(tip).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
        .animation(.easeInOut, value: showTips)
    }

    private var writingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your Writing")
                    .font(.headline).fontWeight(.semibold)
                Spacer()
                if isSaved {
                    Label("Saved", systemImage: "checkmark.circle.fill")
                        .font(.caption).fontWeight(.semibold).foregroundColor(.green)
                }
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(minHeight: 220)

                if todayText.isEmpty {
                    Text("Start writing here...\n\nDescribe what you learned from the documentary videos this week. Use your own words and ideas.")
                        .font(.body)
                        .foregroundColor(Color(.placeholderText))
                        .padding(14)
                }

                TextEditor(text: $todayText)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(10)
                    .frame(minHeight: 220)
                    .onChange(of: todayText) { _ in isSaved = false }
            }
        }
    }

    private var wordCountMeter: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(wc) words")
                    .font(.subheadline).fontWeight(.semibold)
                    .foregroundColor(wcColor)
                Text("· \(wcMessage)")
                    .font(.subheadline)
                    .foregroundColor(wcColor)
                Spacer()
                Text("Goal: 100")
                    .font(.caption).foregroundColor(.secondary)
            }

            ProgressView(value: Double(min(wc, 100)), total: 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: wcColor))
                .scaleEffect(x: 1, y: 2, anchor: .center)
        }
        .padding(.horizontal, 4)
    }

    private var saveButton: some View {
        let canSave = wc >= 20 && !isSaved
        return Button(action: saveWriting) {
            HStack(spacing: 10) {
                Image(systemName: isSaved ? "checkmark.circle.fill" : "square.and.arrow.down")
                    .font(.title3)
                Text(isSaved ? "Writing Saved!" :
                     wc < 20 ? "Write at least 20 words to save" :
                     "Save Writing & Mark Day Complete")
                    .font(.headline).fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isSaved  ? [Color.green, Color.green.opacity(0.8)]
                          : canSave ? [Color.orange, Color.red]
                                    : [Color.gray, Color.gray.opacity(0.7)],
                    startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(14)
        }
        .disabled(!canSave)
    }

    private var pastWritingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showHistory.toggle() } }) {
                HStack {
                    Text("Past Writings")
                        .font(.headline).fontWeight(.semibold).foregroundColor(.primary)
                    Spacer()
                    Image(systemName: showHistory ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if showHistory {
                ForEach(writings.sorted(by: { $0.key < $1.key }), id: \.key) { key, text in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(key.replacingOccurrences(of: "week3_day_", with: "Day "))
                                .font(.caption).fontWeight(.semibold).foregroundColor(.orange)
                            Spacer()
                            Text("\(text.split { $0.isWhitespace }.count) words")
                                .font(.caption).foregroundColor(.secondary)
                        }
                        Text(text)
                            .font(.subheadline).foregroundColor(.secondary)
                            .lineLimit(4)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                }
            }
        }
    }

    // MARK: - Logic

    private func loadData() {
        let ud = UserDefaults.standard
        if let data = ud.data(forKey: "week3Writings"),
           let saved = try? JSONDecoder().decode([String: String].self, from: data) {
            writings = saved
            todayText = saved[todayKey] ?? ""
            isSaved = saved[todayKey] != nil
        }
    }

    private func saveWriting() {
        guard wc >= 20 else { return }
        writings[todayKey] = todayText
        if let data = try? JSONEncoder().encode(writings) {
            UserDefaults.standard.set(data, forKey: "week3Writings")
        }
        isSaved = true
        dataStore.markWeek3DayCompleted()
    }
}

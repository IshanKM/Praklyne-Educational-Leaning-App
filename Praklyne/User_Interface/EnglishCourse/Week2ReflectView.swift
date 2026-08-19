import SwiftUI

// MARK: - Week 2: Reflect on Ideas

struct Week2ReflectView: View {
    @ObservedObject var dataStore: CourseDataStore
    @Environment(\.dismiss) private var dismiss

    @State private var reflections: [String: String] = [:]
    @State private var todayText: String = ""
    @State private var isSaved: Bool = false
    @State private var showHistory: Bool = false

    private let prompts = [
        "💡 What was the most interesting idea you learned?",
        "🤔 What surprised you the most?",
        "🔗 How does this connect to something you already know?",
        "❓ What question did this raise for you?",
        "🌍 How could this knowledge be useful in daily life?"
    ]

    private var todayKey: String {
        "week2_day_\(dataStore.totalDaysCompleted)"
    }

    private var currentDayInWeek: Int {
        (dataStore.totalDaysCompleted % 7) + 1
    }

    private var weekProgressPercent: Int {
        let completed = dataStore.weeklyProgress[1].filter { $0 }.count
        return completed * 100 / 7
    }

    private func dotColor(for index: Int) -> Color {
        if index < currentDayInWeek - 1 {
            return Color.purple
        } else if index == currentDayInWeek - 1 {
            return Color.blue
        } else {
            return Color.gray.opacity(0.3)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    weekHeader
                    promptCard
                    writingSection
                    saveButton
                    if !reflections.isEmpty {
                        pastReflectionsSection
                    }
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Week 2 · Reflect")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
            }
            .onAppear { loadData() }
        }
    }

    // MARK: - Header icon extracted to avoid type-check timeout

    private var headerIcon: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Color.purple, Color.blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 52, height: 52)
            Text("✍️")
                .font(.title2)
        }
    }

    private var headerLabels: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Week 2 — Reflect")
                .font(.title2)
                .fontWeight(.bold)
            Text("Day \(currentDayInWeek) of 7")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var progressDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<7, id: \.self) { i in
                Circle()
                    .fill(dotColor(for: i))
                    .frame(width: 10, height: 10)
            }
            Spacer()
            Text("\(weekProgressPercent)%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
        }
    }

    private var weekHeader: some View {
        let bg = RoundedRectangle(cornerRadius: 16)
            .fill(Color.purple.opacity(0.07))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.purple.opacity(0.2), lineWidth: 1)
            )

        return VStack(spacing: 10) {
            HStack(spacing: 12) {
                headerIcon
                headerLabels
                Spacer()
            }
            progressDots
        }
        .padding(16)
        .background(bg)
    }

    // MARK: - Prompt card

    private var promptCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's Reflection Prompts")
                .font(.headline)
                .fontWeight(.semibold)
            Text("Think about the documentary videos from Week 1. Use these questions to guide your thoughts:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(prompts, id: \.self) { prompt in
                    Text(prompt)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.vertical, 2)
                }
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
    }

    // MARK: - Writing area

    private var writingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Your Reflection")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                if isSaved {
                    Label("Saved", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(minHeight: 180)

                if todayText.isEmpty {
                    Text("Write your thoughts here...\n\nWhat ideas did the documentary videos give you?")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(14)
                }

                TextEditor(text: $todayText)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(10)
                    .frame(minHeight: 180)
                    .onChange(of: todayText) { _ in isSaved = false }
            }

            wordCountRow
        }
    }

    private var wordCountRow: some View {
        let wc = wordCount(todayText)
        return HStack {
            Spacer()
            Text("\(wc) word\(wc == 1 ? "" : "s")")
                .font(.caption)
                .foregroundColor(wc >= 50 ? .green : .secondary)
            if wc >= 50 {
                Text("· Great reflection! 🎉")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
    }

    // MARK: - Save button

    private var saveButton: some View {
        let isEmpty = todayText.trimmingCharacters(in: .whitespaces).isEmpty
        let colors: [Color] = isSaved ? [.green, .green.opacity(0.8)]
                            : isEmpty ? [.gray, .gray.opacity(0.8)]
                                      : [.purple, .blue]

        return Button(action: saveReflection) {
            HStack(spacing: 10) {
                Image(systemName: isSaved ? "checkmark.circle.fill" : "square.and.arrow.down")
                    .font(.title3)
                Text(isSaved ? "Reflection Saved!" : "Save Reflection & Mark Day Complete")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
            .cornerRadius(14)
        }
        .disabled(isEmpty || isSaved)
    }

    // MARK: - Past reflections

    private var pastReflectionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showHistory.toggle() } }) {
                HStack {
                    Text("Past Reflections")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: showHistory ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if showHistory {
                ForEach(reflections.sorted(by: { $0.key < $1.key }), id: \.key) { key, text in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(key.replacingOccurrences(of: "week2_day_", with: "Day "))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                        Text(text)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
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
        if let data = UserDefaults.standard.data(forKey: "week2Reflections"),
           let saved = try? JSONDecoder().decode([String: String].self, from: data) {
            reflections = saved
            todayText = saved[todayKey] ?? ""
            isSaved = saved[todayKey] != nil
        }
    }

    private func saveReflection() {
        guard !todayText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        reflections[todayKey] = todayText
        if let data = try? JSONEncoder().encode(reflections) {
            UserDefaults.standard.set(data, forKey: "week2Reflections")
        }
        isSaved = true
        dataStore.markWeek2DayCompleted()
    }

    private func wordCount(_ text: String) -> Int {
        text.split(separator: " ").filter { !$0.isEmpty }.count
    }
}

struct Week2ReflectView_Previews: PreviewProvider {
    static var previews: some View {
        Week2ReflectView(dataStore: CourseDataStore())
    }
}

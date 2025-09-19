import SwiftUI


class CourseDataStore: ObservableObject {
    @Published var totalDaysCompleted: Int = 0
    @Published var currentStreak: Int = 0
    @Published var totalHoursSpent: Double = 0.0
    @Published var lastWatchedDate: Date?
    @Published var weeklyProgress: [[Bool]] = Array(repeating: Array(repeating: false, count: 7), count: 4)
    
    init() {
        loadData()
    }
    
    func loadData() {
        totalDaysCompleted = UserDefaults.standard.integer(forKey: "totalDaysCompleted")
        currentStreak = UserDefaults.standard.integer(forKey: "currentStreak")
        totalHoursSpent = UserDefaults.standard.double(forKey: "totalHoursSpent")
        
        if let dateData = UserDefaults.standard.data(forKey: "lastWatchedDate"),
           let date = try? JSONDecoder().decode(Date.self, from: dateData) {
            lastWatchedDate = date
        }
        
        if let weekData = UserDefaults.standard.data(forKey: "weeklyProgress"),
           let weeks = try? JSONDecoder().decode([[Bool]].self, from: weekData) {
            weeklyProgress = weeks
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(totalDaysCompleted, forKey: "totalDaysCompleted")
        UserDefaults.standard.set(currentStreak, forKey: "currentStreak")
        UserDefaults.standard.set(totalHoursSpent, forKey: "totalHoursSpent")
        
        if let date = lastWatchedDate,
           let dateData = try? JSONEncoder().encode(date) {
            UserDefaults.standard.set(dateData, forKey: "lastWatchedDate")
        }
        
        if let weekData = try? JSONEncoder().encode(weeklyProgress) {
            UserDefaults.standard.set(weekData, forKey: "weeklyProgress")
        }
    }
    
    func canWatchToday() -> Bool {
        guard let lastDate = lastWatchedDate else { return true }
        return !Calendar.current.isDateInToday(lastDate)
    }
    
    func markVideoWatched(duration: String) {
        guard canWatchToday() else { return }
        
        let hours = durationToHours(duration)
        
        totalDaysCompleted += 1
        totalHoursSpent += hours
        lastWatchedDate = Date()
        
        if let lastDate = lastWatchedDate,
           Calendar.current.isDate(lastDate, inSameDayAs: Date().addingTimeInterval(-86400)) {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        
        let currentWeek = min(totalDaysCompleted / 7, 3)
        let dayInWeek = (totalDaysCompleted - 1) % 7
        weeklyProgress[currentWeek][dayInWeek] = true
        
        saveData()
    }
    
    private func durationToHours(_ duration: String) -> Double {
        let components = duration.split(separator: ":").compactMap { Double($0) }
        if components.count == 2 {
            return components[0] / 60 + components[1] / 3600
        }
        return 0.75
    }
}

struct CourseProgressView: View {
    @StateObject private var dataStore = CourseDataStore()
    @State private var showVideoPlayer = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Practice English in")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                Text("  One Month ")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                                    .frame(width: 80, height: 80)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(dataStore.totalDaysCompleted) / 28.0)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.blue, Color.purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                                    )
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                                
                                VStack(spacing: 2) {
                                    Text("\(Int((Double(dataStore.totalDaysCompleted) / 28.0) * 100))%")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("Complete")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Course Progress")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(dataStore.totalDaysCompleted)/28 days")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            ProgressView(value: Double(dataStore.totalDaysCompleted), total: 28.0)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                                .scaleEffect(x: 1, y: 2, anchor: .center)
                        }
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ProgressCard(
                            title: "Days Completed",
                            value: "\(dataStore.totalDaysCompleted)",
                            subtitle: "Total days",
                            color: .blue
                        )
                        
                        ProgressCard(
                            title: "Current Streak",
                            value: "\(dataStore.currentStreak)",
                            subtitle: "Days in a row",
                            color: .green
                        )
                        
                        ProgressCard(
                            title: "Hours Spent",
                            value: String(format: "%.1f", dataStore.totalHoursSpent),
                            subtitle: "Total hours",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        showVideoPlayer = true
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                            Text(dataStore.canWatchToday() ? "Continue Learning" : "Come Back Tomorrow")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: dataStore.canWatchToday() ? [Color.blue, Color.purple] : [Color.gray, Color.gray.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(!dataStore.canWatchToday())
                    
                    if !dataStore.canWatchToday() {
                        Text("You've already watched a video today! 🎉")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("4-Week Journey")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ForEach(0..<4, id: \.self) { weekIndex in
                            WeekProgressView(
                                weekNumber: weekIndex + 1,
                                weekProgress: dataStore.weeklyProgress[weekIndex],
                                isCurrentWeek: getCurrentWeek() == weekIndex,
                                isCompleted: dataStore.weeklyProgress[weekIndex].allSatisfy { $0 }
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Course Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showVideoPlayer) {
            CourseVideoView(dataStore: dataStore)
        }
    }
    
    private func getCurrentWeek() -> Int {
        return min(dataStore.totalDaysCompleted / 7, 3)
    }
    
    private func dayName(for index: Int) -> String {
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        return days[index]
    }
}

struct ProgressCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            }
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WeekProgressView: View {
    let weekNumber: Int
    let weekProgress: [Bool]
    let isCurrentWeek: Bool
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isCompleted ? .green : .gray)
                        .font(.title3)
                    
                    Text("Week \(weekNumber)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isCurrentWeek ? .primary : .secondary)
                }
                
                Spacer()
                
                if isCurrentWeek {
                    Text("Current")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
            
            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { dayIndex in
                    VStack(spacing: 6) {
                        Text(dayName(for: dayIndex))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(weekProgress[dayIndex] ?
                                  LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing) :
                                  LinearGradient(colors: [.gray.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: weekProgress[dayIndex] ? "checkmark" : "")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                            .shadow(color: weekProgress[dayIndex] ? .green.opacity(0.3) : .clear, radius: 4)
                    }
                }
            }
            
            ProgressView(value: Double(weekProgress.filter { $0 }.count), total: 7.0)
                .progressViewStyle(LinearProgressViewStyle(tint: isCurrentWeek ? .blue : .green))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isCurrentWeek ? Color.blue.opacity(0.05) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isCurrentWeek ? Color.blue.opacity(0.3) : Color.clear, lineWidth: 1)
        )

    }
    
    private func dayName(for index: Int) -> String {
        let days = ["S", "M", "T", "W", "T", "F", "S"]
        return days[index]
    }
}



struct CourseProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CourseProgressView()
    }
}

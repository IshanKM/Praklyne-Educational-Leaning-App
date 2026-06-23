import SwiftUI
import FirebaseAuth

// MARK: - Redesigned Settings & Profile View
struct SettingsView: View {
    @Binding var user: UserModel?
    @ObservedObject var lockManager: LockManager
    @ObservedObject var libraryStore = VideoLibraryStore.shared
    
    // AppStorage states for preferences
    @AppStorage("user_streak") private var streakCount = 3
    @AppStorage("learn_minutes") private var learnMinutes = 45
    @AppStorage("daily_study_goal_minutes") private var dailyGoalMinutes = 15
    @AppStorage("daily_reminder_enabled") private var dailyReminderEnabled = false
    @AppStorage("autoplay_shorts") private var autoplayShorts = true
    @AppStorage("speech_rate") private var speechRate = 0.5
    
    // States for local controls
    @State private var reminderTime = Date()
    @State private var newPIN = ""
    @State private var navigateToAbout = false
    @State private var showPINSavedAlert = false
    @State private var showLogoutAlert = false
    @State private var showClearHistoryAlert = false
    @State private var showHistoryClearedToast = false
    
    private let goalOptions = [5, 10, 15, 30, 45, 60]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // ── Header / Profile Section ──────────────────────────────────
                    profileHeader
                    
                    // ── Stats Dashboard ──────────────────────────────────────────
                    statsDashboard
                    
                    // ── Daily Goals & Reminders Section ────────────────────────────
                    SettingsCardSection(header: "Daily Goals & Reminders") {
                        // Study Goal Picker
                        SettingsRow(
                            icon: "target",
                            iconColor: .orange,
                            title: "Daily Study Goal",
                            subtitle: "Set your target study time",
                            trailingView: AnyView(
                                Picker("", selection: $dailyGoalMinutes) {
                                    ForEach(goalOptions, id: \.self) { mins in
                                        Text("\(mins) mins").tag(mins)
                                    }
                                }
                                .pickerStyle(.menu)
                            )
                        )
                        
                        Divider().padding(.leading, 64)
                        
                        // Daily Reminder Toggle
                        SettingsRow(
                            icon: "bell.fill",
                            iconColor: .red,
                            title: "Daily Reminders",
                            subtitle: "Get notified when it's time to study",
                            trailingView: AnyView(
                                Toggle("", isOn: $dailyReminderEnabled)
                                    .onChange(of: dailyReminderEnabled) { _ in
                                        updateReminder()
                                    }
                            )
                        )
                        
                        if dailyReminderEnabled {
                            Divider().padding(.leading, 64)
                            
                            // Reminder Time Picker
                            SettingsRow(
                                icon: "clock.fill",
                                iconColor: .purple,
                                title: "Reminder Time",
                                subtitle: "Choose when you want to study",
                                trailingView: AnyView(
                                    DatePicker("", selection: $reminderTime, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(.compact)
                                        .onChange(of: reminderTime) { _ in
                                            updateReminder()
                                        }
                                )
                            )
                        }
                    }
                    
                    // ── Video & Audio Preferences Section ───────────────────────────
                    SettingsCardSection(header: "App Preferences") {
                        // Autoplay Shorts Toggle
                        SettingsRow(
                            icon: "play.rectangle.fill",
                            iconColor: .blue,
                            title: "Autoplay Shorts",
                            subtitle: "Automatically play videos on load",
                            trailingView: AnyView(
                                Toggle("", isOn: $autoplayShorts)
                            )
                        )
                        
                        Divider().padding(.leading, 64)
                        
                        // Speech Rate Control
                        VStack(spacing: 8) {
                            SettingsRow(
                                icon: "waveform.circle.fill",
                                iconColor: .green,
                                title: "Pronunciation Speed",
                                subtitle: "Control audio speech rate",
                                trailingView: AnyView(
                                    Button(action: {
                                        SpeechManager.shared.speak("Praklyne. Let's learn together!", rate: speechRate)
                                    }) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.title3)
                                            .foregroundColor(.green)
                                    }
                                    .buttonStyle(.plain)
                                )
                            )
                            
                            HStack(spacing: 12) {
                                Image(systemName: "turtle.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Slider(value: $speechRate, in: 0.3...0.7)
                                    .accentColor(.green)
                                
                                Image(systemName: "hare.fill")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 12)
                        }
                    }
                    
                    // ── Security & Privacy Section ──────────────────────────────────
                    SettingsCardSection(header: "Security & Privacy") {
                        // Face ID Toggle
                        SettingsRow(
                            icon: "faceid",
                            iconColor: .teal,
                            title: "Biometric Login",
                            subtitle: "Unlock Praklyne using Face ID",
                            trailingView: AnyView(
                                Toggle("", isOn: Binding(
                                    get: { lockManager.faceIDEnabled },
                                    set: { lockManager.toggleFaceID($0) }
                                ))
                            )
                        )
                        
                        Divider().padding(.leading, 64)
                        
                        // PIN Toggle
                        SettingsRow(
                            icon: "key.fill",
                            iconColor: .indigo,
                            title: "PIN Code Lock",
                            subtitle: "Secure app using a 4-digit PIN",
                            trailingView: AnyView(
                                Toggle("", isOn: Binding(
                                    get: { lockManager.pinEnabled },
                                    set: { lockManager.togglePIN($0) }
                                ))
                            )
                        )
                        
                        if lockManager.pinEnabled {
                            Divider().padding(.leading, 64)
                            
                            // Save PIN textfield row
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 14) {
                                    Image(systemName: "lock.shield.fill")
                                        .foregroundColor(.indigo)
                                        .frame(width: 32)
                                    
                                    SecureField(lockManager.storedPIN != nil ? "Change 4-Digit PIN" : "Enter 4-Digit PIN", text: $newPIN)
                                        .font(.system(size: 15))
                                        .keyboardType(.numberPad)
                                    
                                    Spacer()
                                    
                                    Button("Save") {
                                        if newPIN.count == 4 {
                                            lockManager.savePIN(newPIN)
                                            newPIN = ""
                                            showPINSavedAlert = true
                                        }
                                    }
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.indigo)
                                    .disabled(newPIN.count != 4)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                        }
                        
                        Divider().padding(.leading, 64)
                        
                        // Clear Search Recents
                        SettingsRow(
                            icon: "trash.fill",
                            iconColor: .red,
                            title: "Clear Search History",
                            subtitle: "Delete all recent search entries",
                            action: {
                                showClearHistoryAlert = true
                            }
                        )
                    }
                    
                    // ── Support & Information Section ──────────────────────────────
                    SettingsCardSection(header: "Information") {
                        SettingsRow(
                            icon: "info.circle.fill",
                            iconColor: .gray,
                            title: "About Praklyne",
                            subtitle: "Learn more about our platform",
                            action: {
                                navigateToAbout = true
                            }
                        )
                    }
                    
                    // ── Action Buttons ─────────────────────────────────────────────
                    logoutButton
                    
                    // ── Footer ─────────────────────────────────────────────────────
                    VStack(spacing: 4) {
                        Text("Praklyne")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                        Text("Version 1.2.0 (Build 42)")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 60)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            
            // Destinations
            .background(
                NavigationLink(destination: AboutView(), isActive: $navigateToAbout) { EmptyView() }
                    .hidden()
            )
        }
        .onAppear {
            loadReminderTime()
        }
        .alert(isPresented: $showPINSavedAlert) {
            Alert(title: Text("Security Update"), message: Text("Your passcode PIN has been saved successfully!"), dismissButton: .default(Text("OK")))
        }
        .alert(isPresented: $showClearHistoryAlert) {
            Alert(
                title: Text("Clear Search History"),
                message: Text("Are you sure you want to clear your recent searches?"),
                primaryButton: .destructive(Text("Clear")) {
                    UserDefaults.standard.removeObject(forKey: "search.recents")
                    withAnimation {
                        showHistoryClearedToast = true
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: – Profile Header
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile image view
            Group {
                if let url = Auth.auth().currentUser?.photoURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Circle().fill(Color.orange.opacity(0.15))
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)
                            )
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.orange, Color(hex: "#FF6B6B")],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        )
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
            }
            .padding(.top, 70) // extra space for notch
            
            // Name and Email
            VStack(spacing: 4) {
                Text(Auth.auth().currentUser?.displayName ?? "Praklyne Student")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(Auth.auth().currentUser?.email ?? "student@praklyne.com")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 24)
        .background(
            LinearGradient(
                colors: [Color.orange.opacity(0.12), Color(.systemGroupedBackground)],
                startPoint: .top, endPoint: .bottom
            )
        )
    }
    
    // MARK: – Stats Dashboard
    private var statsDashboard: some View {
        HStack(spacing: 12) {
            // Card 1: Streak
            VStack(spacing: 6) {
                Text("🔥")
                    .font(.system(size: 22))
                Text("\(streakCount) Days")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Streak")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            // Card 2: Goal
            VStack(spacing: 6) {
                Text("⏱️")
                    .font(.system(size: 22))
                Text("\(learnMinutes)m")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Study Time")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            
            // Card 3: Saved Items
            VStack(spacing: 6) {
                Text("🔖")
                    .font(.system(size: 22))
                Text("\(libraryStore.savedTitles.count + libraryStore.likedTitles.count) Items")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Saved / Liked")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: – Logout Button
    private var logoutButton: some View {
        Button(action: {
            showLogoutAlert = true
        }) {
            HStack {
                Image(systemName: "power")
                    .font(.system(size: 16, weight: .bold))
                Text("Sign Out")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#FF4B4B"), Color(hex: "#FF6B6B")],
                    startPoint: .leading, endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color(hex: "#FF4B4B").opacity(0.3), radius: 8, y: 3)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Sign Out"),
                message: Text("Are you sure you want to sign out from Praklyne?"),
                primaryButton: .destructive(Text("Sign Out")) {
                    logout()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: – Helpers
    private func logout() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func loadReminderTime() {
        let hour = UserDefaults.standard.integer(forKey: "daily_reminder_hour")
        let minute = UserDefaults.standard.integer(forKey: "daily_reminder_minute")
        
        var components = DateComponents()
        components.hour = hour > 0 ? hour : 20
        components.minute = minute
        if let date = Calendar.current.date(from: components) {
            reminderTime = date
        }
    }
    
    private func updateReminder() {
        if dailyReminderEnabled {
            let components = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            let hour = components.hour ?? 20
            let minute = components.minute ?? 0
            UserDefaults.standard.set(hour, forKey: "daily_reminder_hour")
            UserDefaults.standard.set(minute, forKey: "daily_reminder_minute")
            NotificationManager.shared.scheduleDailyReminder(hour: hour, minute: minute)
        } else {
            NotificationManager.shared.cancelDailyReminder()
        }
    }
}

// MARK: - Reusable Settings Card Section
struct SettingsCardSection<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 22)
    }
}

// MARK: - Reusable Settings Row
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var subtitle: String? = nil
    var trailingView: AnyView? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        let rowContent = HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if let trailing = trailingView {
                trailing
            } else if action != nil {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(.tertiaryLabel))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        
        if let act = action {
            Button(action: act) {
                rowContent
            }
            .buttonStyle(.plain)
        } else {
            rowContent
        }
    }
}

// MARK: - About Page Redesign
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // Logo Card
                ZStack {
                    LinearGradient(
                        colors: [Color.orange, Color(hex: "#FF6B6B")],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                    .shadow(color: Color.orange.opacity(0.3), radius: 10, y: 5)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                
                VStack(spacing: 6) {
                    Text("Praklyne")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Learn. Practice. Excel.")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.orange)
                }
                
                // Main Info card
                VStack(alignment: .leading, spacing: 18) {
                    Label("Platform Mission", systemImage: "sparkles")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.orange)
                    
                    Text("Praklyne is a next-generation educational application designed to make learning interactive, visual, and highly efficient. We combine micro-learning video shorts, rich key concept highlights, diagrams, and bilingual translation tools to accommodate students of all backgrounds.")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                    
                    Divider()
                    
                    Label("Core Features", systemImage: "star.fill")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        BulletRow(text: "🎥 Short Videos: Quick, high-impact conceptual video shorts.")
                        BulletRow(text: "📚 Dynamic Vocabulary: Master Sinhala and English vocabulary.")
                        BulletRow(text: "⚡ Universal Search: Search across subjects, topics, and videos.")
                        BulletRow(text: "⏰ Smart Goal Reminders: Custom schedules to build study habits.")
                    }
                }
                .padding(20)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 20)
                
                Spacer(minLength: 40)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("About")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                        .font(.system(size: 15, weight: .bold))
                }
            }
        }
    }
}

// MARK: - Reusable Bullet Row
struct BulletRow: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.system(size: 13))
            .foregroundColor(.secondary)
    }
}

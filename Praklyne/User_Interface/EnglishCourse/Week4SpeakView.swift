import SwiftUI
import AVFoundation

// MARK: - Week 4: Record Reflections & Develop Verbal Skills

struct Week4SpeakView: View {
    @ObservedObject var dataStore: CourseDataStore
    @Environment(\.dismiss) private var dismiss

    @StateObject private var recorder = AudioRecorderManager()
    @State private var recordings: [RecordingEntry] = []
    @State private var isSaved: Bool = false
    @State private var showHistory: Bool = false
    @State private var showPermissionAlert: Bool = false

    private var todayKey: String {
        "week4_day_\(dataStore.totalDaysCompleted)"
    }

    private var currentDayInWeek: Int {
        (dataStore.totalDaysCompleted % 7) + 1
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    weekHeader
                    instructionCard
                    recordingControls
                    saveSection

                    if !recordings.isEmpty {
                        pastRecordingsSection
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Week 4 · Speak")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                }
            }
            .alert("Microphone Access Required", isPresented: $showPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please allow microphone access in Settings so you can record your speaking exercises.")
            }
            .onAppear { loadRecordings() }
            .onDisappear { recorder.stopPlayback() }
        }
    }

    // MARK: - Sub-views

    private var weekHeader: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.green, Color.teal],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 52, height: 52)
                    Text("🎙️")
                        .font(.title2)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Week 4 — Speak")
                        .font(.title2).fontWeight(.bold)
                    Text("Day \(currentDayInWeek) of 7")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 8) {
                ForEach(0..<7, id: \.self) { i in
                    Circle()
                        .fill(i < currentDayInWeek - 1 ? Color.green :
                              i == currentDayInWeek - 1 ? Color.teal : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                }
                Spacer()
                Text("\(dataStore.weeklyProgress[3].filter { $0 }.count)/7 days done")
                    .font(.caption).fontWeight(.semibold).foregroundColor(.green)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.green.opacity(0.07))
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.green.opacity(0.2), lineWidth: 1))
        )
    }

    private var instructionCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Speaking Exercise", systemImage: "waveform.and.mic")
                .font(.headline).fontWeight(.semibold)

            Text("Record yourself speaking about what you learned from the documentary videos. Talk about your ideas, opinions, and feelings — in English!")
                .font(.subheadline).foregroundColor(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                speakingTip(icon: "1.circle.fill", text: "What was the documentary about?")
                speakingTip(icon: "2.circle.fill", text: "What was the most interesting fact?")
                speakingTip(icon: "3.circle.fill", text: "How did it make you feel?")
                speakingTip(icon: "4.circle.fill", text: "What would you tell a friend about it?")
            }

            Text("Try to speak for at least 1 minute 🎯")
                .font(.caption).fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
    }

    private func speakingTip(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.subheadline)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }

    private var recordingControls: some View {
        VStack(spacing: 20) {
            // Live waveform / timer
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(recorder.isRecording
                        ? Color.red.opacity(0.08)
                        : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(recorder.isRecording ? Color.red.opacity(0.4) : Color.clear, lineWidth: 1.5)
                    )

                VStack(spacing: 12) {
                    if recorder.isRecording {
                        // Pulsing mic icon
                        Image(systemName: "mic.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.red)
                            .scaleEffect(recorder.isRecording ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                       value: recorder.isRecording)

                        Text(recorder.formattedTime)
                            .font(.system(size: 28, weight: .bold, design: .monospaced))
                            .foregroundColor(.red)

                        Text("Recording... Speak clearly")
                            .font(.subheadline).foregroundColor(.secondary)
                    } else if recorder.hasRecording {
                        Image(systemName: "waveform")
                            .font(.system(size: 36))
                            .foregroundColor(.green)
                        Text("Recording ready")
                            .font(.headline).foregroundColor(.green)
                        Text(recorder.formattedTime + " recorded")
                            .font(.subheadline).foregroundColor(.secondary)
                    } else {
                        Image(systemName: "mic.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("Tap below to start recording")
                            .font(.subheadline).foregroundColor(.secondary)
                    }
                }
                .padding(24)
            }
            .frame(minHeight: 160)

            // Record / Stop button
            Button(action: toggleRecording) {
                HStack(spacing: 12) {
                    Image(systemName: recorder.isRecording ? "stop.circle.fill" : "mic.fill")
                        .font(.title2)
                    Text(recorder.isRecording ? "Stop Recording" : "Start Recording")
                        .font(.headline).fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(recorder.isRecording ? Color.red : Color.green)
                .cornerRadius(14)
            }

            // Playback button
            if recorder.hasRecording {
                Button(action: togglePlayback) {
                    HStack(spacing: 10) {
                        Image(systemName: recorder.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title2)
                        Text(recorder.isPlaying ? "Pause Playback" : "Play Back Recording")
                            .font(.headline).fontWeight(.semibold)
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.green.opacity(0.12))
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.green.opacity(0.4), lineWidth: 1))
                }
            }
        }
    }

    private var saveSection: some View {
        Button(action: saveRecording) {
            HStack(spacing: 10) {
                Image(systemName: isSaved ? "checkmark.circle.fill" : "square.and.arrow.down")
                    .font(.title3)
                Text(isSaved ? "Recording Saved!" :
                     !recorder.hasRecording ? "Record first to save" :
                     "Save Recording & Mark Day Complete")
                    .font(.headline).fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: isSaved           ? [Color.green, Color.green.opacity(0.8)]
                          : recorder.hasRecording ? [Color.teal, Color.green]
                                              : [Color.gray, Color.gray.opacity(0.7)],
                    startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(14)
        }
        .disabled(!recorder.hasRecording || isSaved)
    }

    private var pastRecordingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { showHistory.toggle() } }) {
                HStack {
                    Text("Past Recordings (\(recordings.count))")
                        .font(.headline).fontWeight(.semibold).foregroundColor(.primary)
                    Spacer()
                    Image(systemName: showHistory ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if showHistory {
                ForEach(recordings) { entry in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 40, height: 40)
                            Image(systemName: "waveform")
                                .foregroundColor(.green)
                        }
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Day \(entry.day)")
                                .font(.subheadline).fontWeight(.semibold)
                            Text(entry.dateString)
                                .font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(entry.duration)
                            .font(.caption).fontWeight(.semibold)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                }
            }
        }
    }

    // MARK: - Logic

    private func toggleRecording() {
        if recorder.isRecording {
            recorder.stopRecording()
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    if granted {
                        recorder.startRecording(for: todayKey)
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
        }
    }

    private func togglePlayback() {
        if recorder.isPlaying {
            recorder.stopPlayback()
        } else {
            recorder.playRecording()
        }
    }

    private func saveRecording() {
        guard recorder.hasRecording else { return }
        let entry = RecordingEntry(
            day: dataStore.totalDaysCompleted,
            fileKey: todayKey,
            duration: recorder.formattedTime,
            dateString: DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        )
        recordings.append(entry)
        if let data = try? JSONEncoder().encode(recordings) {
            UserDefaults.standard.set(data, forKey: "week4Recordings")
        }
        isSaved = true
        dataStore.markWeek4DayCompleted()
    }

    private func loadRecordings() {
        if let data = UserDefaults.standard.data(forKey: "week4Recordings"),
           let saved = try? JSONDecoder().decode([RecordingEntry].self, from: data) {
            recordings = saved
            isSaved = saved.contains { $0.day == dataStore.totalDaysCompleted }
        }
    }
}

// MARK: - Recording Entry Model

struct RecordingEntry: Codable, Identifiable {
    let id: UUID
    let day: Int
    let fileKey: String
    let duration: String
    let dateString: String

    init(day: Int, fileKey: String, duration: String, dateString: String) {
        self.id = UUID()
        self.day = day
        self.fileKey = fileKey
        self.duration = duration
        self.dateString = dateString
    }
}

// MARK: - AudioRecorderManager

final class AudioRecorderManager: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @Published var isRecording: Bool = false
    @Published var isPlaying: Bool = false
    @Published var hasRecording: Bool = false
    @Published var elapsedSeconds: Int = 0

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var currentFileURL: URL?

    var formattedTime: String {
        let mins = elapsedSeconds / 60
        let secs = elapsedSeconds % 60
        return String(format: "%d:%02d", mins, secs)
    }

    func startRecording(for key: String) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print("Audio session error: \(error)")
            return
        }

        let url = recordingURL(for: key)
        currentFileURL = url

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            hasRecording = false
            elapsedSeconds = 0
            startTimer()
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        hasRecording = true
        stopTimer()
    }

    func playRecording() {
        guard let url = currentFileURL else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Playback error: \(error)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func recordingURL(for key: String) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("\(key).m4a")
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully: Bool) {
        isRecording = false
        hasRecording = successfully
        stopTimer()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully: Bool) {
        isPlaying = false
    }
}

struct Week4SpeakView_Previews: PreviewProvider {
    static var previews: some View {
        Week4SpeakView(dataStore: CourseDataStore())
    }
}



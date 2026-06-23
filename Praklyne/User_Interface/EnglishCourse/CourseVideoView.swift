
import SwiftUI
import WebKit
import CoreML

struct DocumentaryVideo {
    let id: String
    let title: String
    let youtubeID: String
    let duration: String
    let description: String
    let transcript: String
}

struct CourseVideoView: View {
    @ObservedObject var dataStore: CourseDataStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVideo: DocumentaryVideo
    @State private var showMarkCompleteAlert = false
    
    @State private var isShowingSummary = false
    @State private var summarizedText = ""
    @State private var isLoadingSummary = false
    
    init(dataStore: CourseDataStore) {
        self.dataStore = dataStore
        self._selectedVideo = State(initialValue: documentaryVideos[0])
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 20) {
                        
                        YouTubePlayerView(videoID: selectedVideo.youtubeID)
                            .frame(height: 220)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text(selectedVideo.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.secondary)
                                Text(selectedVideo.duration)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(selectedVideo.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Science Documentary Playlist")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                            
                            LazyVStack(spacing: 12) {
                                ForEach(documentaryVideos, id: \.id) { video in
                                    VideoRowView(
                                        video: video,
                                        isSelected: video.id == selectedVideo.id
                                    ) {
                                        selectedVideo = video
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Fixed bottom buttons
                VStack(spacing: 12) {
                    Button(action: {
                        summarizeVideo(video: selectedVideo)
                    }) {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Summarize")
                        }
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        if dataStore.canWatchToday() {
                            showMarkCompleteAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Mark As Complete this Video")
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(dataStore.canWatchToday() ? Color.green : Color.gray)
                        .cornerRadius(8)
                    }
                    .disabled(!dataStore.canWatchToday())
                }
                .padding()
            }
            .navigationTitle("Documentary Learning")
            .navigationBarTitleDisplayMode(.inline)
            
            // Summary sheet
            .sheet(isPresented: $isShowingSummary) {
                VStack(spacing: 20) {
                    Text("Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if isLoadingSummary {
                        ProgressView("Summarizing...")
                            .padding()
                    } else {
                        ScrollView {
                            Text(summarizedText)
                                .padding()
                        }
                    }
                    
                    Button("Close") {
                        isShowingSummary = false
                    }
                    .padding()
                }
                .padding()
            }
            
            // Alert for marking complete
            .alert("Mark Video Complete", isPresented: $showMarkCompleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Complete") {
                    dataStore.markVideoWatched(duration: selectedVideo.duration)
                    dismiss()
                }
            } message: {
                Text("Mark '\(selectedVideo.title)' as watched? You won't be able to watch another video today.")
            }
        }
    }
    
    func summarizeVideo(video: DocumentaryVideo) {
        guard let url = URL(string: "http://127.0.0.1:5000/summarize") else { return }
        
        let json: [String: Any] = ["text": video.transcript]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        isLoadingSummary = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoadingSummary = false
                if let data = data,
                   let result = try? JSONDecoder().decode([String: String].self, from: data),
                   let summary = result["summary"] {
                    summarizedText = summary
                    isShowingSummary = true
                } else {
                    summarizedText = "No Transcript Found."
                    isShowingSummary = true
                }
            }
        }.resume()
    }
}

struct VideoRowView: View {
    let video: DocumentaryVideo
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 45)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Text(video.duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct YouTubePlayerView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsAirPlayForMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .black
        webView.isOpaque = false

        // Give it a clean Safari identity string
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !videoID.isEmpty else { return }
        if uiView.accessibilityIdentifier == videoID { return }
        uiView.accessibilityIdentifier = videoID
        
        // Point directly to the secure nocookie web endpoint URL structure
        let urlString = "https://www.youtube-nocookie.com/embed/\(videoID)?playsinline=1&rel=0&modestbranding=1&controls=1&enablejsapi=1"

        guard let url = URL(string: urlString) else { return }

        // THE FIX: Send app bundle identifier signature as the security referer domain
        var request = URLRequest(url: url)
        request.setValue("https://com.Praklyne.Educational.App", forHTTPHeaderField: "Referer")
        request.setValue("https://com.Praklyne.Educational.App", forHTTPHeaderField: "Origin")

        uiView.load(request)
    }
}

class MockCourseDataStore: CourseDataStore {
    override func canWatchToday() -> Bool { true }
    override func markVideoWatched(duration: String) {}
}

struct CourseVideoView_Previews: PreviewProvider {
    static var previews: some View {
        CourseVideoView(dataStore: MockCourseDataStore())
    }
}


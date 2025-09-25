import SwiftUI
import WebKit

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
    
    let documentaryVideos = [
        DocumentaryVideo(
            id: "1",
            title: "Black Holes Explained - From Birth to Death",
            youtubeID: "GUZauFzCyG0",
            duration: "45:30",
            description: "Explore the mysterious world of black holes and their incredible journey from formation to evaporation.",
            transcript: "Black holes are regions of spacetime exhibiting gravitational acceleration so strong that nothing—no particles or even electromagnetic radiation such as light-can escape from it..."
        ),
        DocumentaryVideo(
            id: "2",
            title: "Our Solar System - A Cosmic Journey",
            youtubeID: "libKVRa01L8",
            duration: "52:15",
            description: "Take a breathtaking tour through our solar system and discover the wonders of each planet.",
            transcript: "The solar system consists of the Sun and the objects that orbit it, including planets, moons, asteroids, comets, and meteoroids..."
        ),
        DocumentaryVideo(
            id: "3",
            title: "Ancient Earth - 4 Billion Years of History",
            youtubeID: "H2OfgmaaH48",
            duration: "48:20",
            description: "Journey through Earth's incredible 4-billion-year history and witness the evolution of life.",
            transcript: "Earth has undergone dramatic changes over 4 billion years, from molten surface to formation of oceans, continents, and life..."
        ),
        DocumentaryVideo(
            id: "4",
            title: "The Elements - Building Blocks of Everything",
            youtubeID: "yQP4UJhNn0I",
            duration: "41:45",
            description: "Discover how the elements were forged in the hearts of stars and shaped our universe.",
            transcript: "All matter is made from elements formed in stars through nuclear fusion. These elements combine to form molecules and eventually planets..."
        )
    ]
    
    init(dataStore: CourseDataStore) {
        self.dataStore = dataStore
        self._selectedVideo = State(initialValue: documentaryVideos[0])
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
              
                YouTubePlayerView(videoID: selectedVideo.youtubeID)
                    .frame(height: 220)
                    .cornerRadius(12)
                    .padding()
                
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
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Science Documentary Playlist")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    ScrollView {
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
                    .frame(maxHeight: 200)
                }
                
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
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                }
            )
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
                    summarizedText = "Failed to get summary."
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
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedHTML = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body { margin: 0; padding: 0; background: black; }
                .video-container { position: relative; width: 100%; height: 100vh; }
                iframe { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
            </style>
        </head>
        <body>
            <div class="video-container">
                <iframe src="https://www.youtube.com/embed/\(videoID)?playsinline=1&controls=1&showinfo=0&rel=0"
                        frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                </iframe>
            </div>
        </body>
        </html>
        """
        
        uiView.loadHTMLString(embedHTML, baseURL: nil)
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


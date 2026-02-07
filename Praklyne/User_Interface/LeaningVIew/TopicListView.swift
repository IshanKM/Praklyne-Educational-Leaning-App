import SwiftUI
import WebKit


struct TopicsListView: View {
    let learningSubject: LearningSubject
    
    var topics: [Topic] {
        allTopics.filter { $0.subject == learningSubject.name }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(topics) { topic in
                    NavigationLink(destination: TopicDetailView(topic: topic, subjectColor: learningSubject.color)) {
                        TopicRowView(topic: topic, subjectColor: learningSubject.color)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .navigationTitle(learningSubject.name)
        .navigationBarTitleDisplayMode(.large)
    }
}



struct TopicRowView: View {
    let topic: Topic
    let subjectColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "play.circle.fill")
                .font(.title2)
                .foregroundColor(subjectColor)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(topic.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}




struct VideoRowViewSubject: View {
    let video: TopicVideo
    let subjectColor: Color
    @State private var showVideoPlayer = false
    
    var body: some View {
        Button {
            showVideoPlayer = true
        } label: {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 60)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(subjectColor)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(video.duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $showVideoPlayer) {
            CourseVideoViewSubject(videoTitle: video.title, videoUrl: video.videoUrl)
        }
    }
}



struct CourseVideoViewSubject: View {
    let videoTitle: String
    let videoUrl: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(videoTitle)
                .font(.title2)
                .bold()
                .padding(.top, 16)
            
            if let videoID = getYouTubeID(from: videoUrl) {
                LearningYouTubeVideoPlayer(videoID: videoID)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            } else {
                Text("Invalid video URL")
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Video Player")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func getYouTubeID(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        if url.host?.contains("youtu.be") == true {
            return url.lastPathComponent
        } else if url.host?.contains("youtube.com") == true {
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                return queryItems.first(where: { $0.name == "v" })?.value
            }
        }
        return nil
    }
}


struct LearningYouTubeVideoPlayer: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <html><body style="margin:0;">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=0&controls=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
        </body></html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }
}


struct TopicsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TopicsListView(
                learningSubject: LearningSubject(
                    id: 1,
                    name: "Science",
                    color: .blue
                )
            )
        }
    }
}

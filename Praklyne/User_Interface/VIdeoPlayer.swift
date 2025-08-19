import SwiftUI
import WebKit


struct VideoShortsView: View {
    @State private var currentVideoIndex = 0
    @State private var isBookmarked = false
    
    let videos: [VideoData] = [
        VideoData(
            title: "Air Pressure",
            youtubeLink: "6FC2IJqAl9g",
            category: "Science",
            description: "Demonstrating what happens to particles when heated."
        ),
        VideoData(
            title: "Chemical Reactions",
            youtubeLink: "GQc7pwuaq9A",
            category: "Chemistry",
            description: "Understanding basic chemical reactions in daily life"
        ),
        VideoData(
            title: "Newton’s Laws",
            youtubeLink: "VXwHPPYkJD8",
            category: "Physics",
            description: "Newton's Laws through simple experiments"
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            YouTubePlayerView(videoID: extractVideoID(from: videos[currentVideoIndex].youtubeLink))
                .ignoresSafeArea()
            
        
            VStack {
                HStack {
                    Text(videos[currentVideoIndex].title)
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    Spacer()
                    
                    Button {
            
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                            Text("Learn this Theory")
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(Color.green)
                        .cornerRadius(20)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
                
                Spacer()
            }
            

            VStack {
                Spacer()
                VStack(spacing: 20) {
                    Button { previousVideo() } label: {
                        Image(systemName: "chevron.up")
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    Button { nextVideo() } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                }
                .padding(.trailing, 20)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            
   
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(videos[currentVideoIndex].description)
                            .foregroundColor(.white)
                            .font(.body)
                        Text(videos[currentVideoIndex].category)
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    Button {
                        isBookmarked.toggle()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 85)
            }
            
  
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    TabBarButton(icon: "house.fill", selected: false)
                    TabBarButton(icon: "magnifyingglass", selected: false)
                    TabBarButton(icon: "play.rectangle.fill", selected: true)
                    TabBarButton(icon: "clock.fill", selected: false)
                    TabBarButton(icon: "person.fill", selected: false)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 50 {
                        previousVideo()
                    } else if value.translation.height < -50 {
                        nextVideo()
                    }
                }
        )
    }
    
    func nextVideo() {
        if currentVideoIndex < videos.count - 1 {
            currentVideoIndex += 1
        }
    }
    func previousVideo() {
        if currentVideoIndex > 0 {
            currentVideoIndex -= 1
        }
    }
    
    func extractVideoID(from link: String) -> String {
        var urlString = link
        

        if link.contains("http") {
            if let url = URL(string: link) {
                urlString = url.lastPathComponent
            }
   
            if let range = link.range(of: "v=") {
                let start = range.upperBound
                let end   = link.firstIndex(of: "&") ?? link.endIndex
                return String(link[start..<end])
            }
        }
        
        
        return urlString
    }
    
    

    struct YouTubePlayerView: UIViewRepresentable {
        var videoID: String
        
        func makeUIView(context: Context) -> WKWebView {
            let config = WKWebViewConfiguration()
            config.allowsInlineMediaPlayback = true
            let webview = WKWebView(frame: .zero, configuration: config)
            webview.scrollView.isScrollEnabled = false
            return webview
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            let html = """
         <html>
             <body style="margin:0;padding:0;background-color:black;">
                <iframe width="100%" height="100%"
                    src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=1&mute=1&controls=0"
                    frameborder="0"
                    allow="autoplay; encrypted-media"
                    allowfullscreen></iframe>
             </body>
         </html>
        """
            uiView.loadHTMLString(html, baseURL: nil)
        }
    }
    
 
    
    struct VideoData {
        let title: String
        let youtubeLink: String
        let category: String
        let description: String
    }
    
    struct TabBarButton: View {
        let icon: String
        let selected: Bool
        
        var body: some View {
            Button(action: {}) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(selected ? .blue : .gray)
                    .frame(maxWidth: .infinity)
            }
        }
    }
    

    
    struct VideoShortsView_Previews: PreviewProvider {
        static var previews: some View {
            VideoShortsView()
        }
    }
}

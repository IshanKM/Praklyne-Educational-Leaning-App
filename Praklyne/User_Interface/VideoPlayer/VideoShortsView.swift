import SwiftUI

struct VideoShortsView: View {
    @StateObject private var service = VideoService()
    @State private var currentIndex = 0
    @State private var isBookmarked = false
    
    let bottomNavHeight: CGFloat = 60  

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if service.videos.isEmpty {
                ProgressView("Loading...")
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding(.bottom, bottomNavHeight)
            } else {
 
                VideoPlayer(videoID: extractVideoID(from: service.videos[currentIndex].youtubeLink))
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text(service.videos[currentIndex].title)
                            .foregroundColor(.white)
                            .font(.title2.bold())
                        Spacer()
                        Button { } label: {
                            HStack {
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
                    VideoSwipeControls(previousAction: previous, nextAction: next)
                    Spacer()
                }.frame(maxWidth: .infinity, alignment: .trailing)
                
                VideoOverlay(video: service.videos[currentIndex], isBookmarked: $isBookmarked)
            }
        }
        .onAppear {
            service.fetchVideos()
        }
    }

    func next() {
        if currentIndex < service.videos.count - 1 {
            currentIndex += 1
        }
    }
    func previous() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
    
    func extractVideoID(from link: String) -> String {
        var urlString = link
        if link.contains("http") {
            if let url = URL(string: link) { urlString = url.lastPathComponent }
            if let range = link.range(of: "v=") {
                return String(link[range.upperBound ..< (link.firstIndex(of: "&") ?? link.endIndex)])
            }
        }
        return urlString
    }
}

    
    struct VideoShortsView_Previews: PreviewProvider {
        static var previews: some View {
            VideoShortsView()
        }
    }


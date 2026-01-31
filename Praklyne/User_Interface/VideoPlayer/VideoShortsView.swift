import SwiftUI

struct VideoShortsView: View {
    @StateObject private var service = VideoService()
    @State private var currentIndex = 0
    
    let bottomNavHeight: CGFloat = 60
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if service.shortVideos.isEmpty {
                ProgressView("Loading...")
                    .foregroundColor(.white)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding(.bottom, bottomNavHeight)
            } else {
                
                VideoPlayer(videoID: extractVideoID(from: service.shortVideos[currentIndex].youtubeLink))
                    .ignoresSafeArea()
                
           
                VStack {
                    HStack {
                        Spacer()
                        Text(service.shortVideos[currentIndex].title)
                            .foregroundColor(.white)
                            .font(.title2.bold())
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    VideoSwipeControls(previousAction: previous, nextAction: next)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                VideoOverlay(video: service.shortVideos[currentIndex])
            }
        }
        .onAppear {
            service.fetchShortVideos()
        }
    }
    
    func next() {
        if currentIndex < service.shortVideos.count - 1 {            currentIndex += 1
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

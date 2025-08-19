import SwiftUI

struct VideoShortsView: View {
    @State private var currentIndex = 0
    @State private var isBookmarked = false

    let videos: [VideoData] = [
        VideoData(title: "Air Pressure", youtubeLink: "6FC2IJqAl9g", category: "Science", description: "Demonstrating what happens to particles when heated."),
        VideoData(title: "Chemical Reactions", youtubeLink: "GQc7pwuaq9A", category: "Chemistry", description: "Understanding basic chemical reactions in daily life."),
        VideoData(title: "Newton’s Laws", youtubeLink: "VXwHPPYkJD8", category: "Physics", description: "Newton's Laws through simple experiments.")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VideoPlayer(videoID: extractVideoID(from: videos[currentIndex].youtubeLink))
                .ignoresSafeArea()

     
            VStack {
                HStack {
                    Text(videos[currentIndex].title)
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

    
            VideoOverlay(video: videos[currentIndex], isBookmarked: $isBookmarked)
        }
        .gesture(
            DragGesture()
                .onEnded {
                    if $0.translation.height > 50 { previous() }
                    else if $0.translation.height < -50 { next() }
                }
        )
    }

    func next() {
        if currentIndex < videos.count - 1 {
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
            if let url = URL(string: link) {
                urlString = url.lastPathComponent
            }
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


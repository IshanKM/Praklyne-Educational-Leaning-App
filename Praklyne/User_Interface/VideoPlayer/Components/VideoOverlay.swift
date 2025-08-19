import SwiftUI

struct VideoOverlay: View {
    let video: VideoData
    @Binding var isBookmarked: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(video.description)
                        .foregroundColor(.white)
                        .font(.body)
                    Text(video.category)
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                Spacer()
                Button { isBookmarked.toggle() } label: {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 85)
        }
    }
}

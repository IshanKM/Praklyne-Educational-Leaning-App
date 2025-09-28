import SwiftUI

struct VideoOverlay: View {
    let video: VideoData
    
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
                .padding(10)
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 85)
        }
    }
}


import Foundation

struct VideoData: Identifiable {
    let id = UUID()
    let title: String
    let youtubeLink: String
    let category: String
    let description: String
}

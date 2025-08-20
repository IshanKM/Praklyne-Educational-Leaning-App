import FirebaseFirestore

class VideoService: ObservableObject {
    @Published var videos: [VideoData] = []
    private let db = Firestore.firestore()
    
    func fetchVideos() {
        db.collection("video_list").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                return
            }
            self.videos = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return VideoData(
                    title: data["title"] as? String ?? "",
                    youtubeLink: data["youtubeId"] as? String ?? "",
                    category: data["category"] as? String ?? "",
                    description: data["description"] as? String ?? ""
                )
            } ?? []
        }
    }
}

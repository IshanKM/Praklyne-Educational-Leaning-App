import FirebaseFirestore

class VideoService: ObservableObject {
    @Published var shortVideos: [VideoData] = []
    @Published var longVideos: [VideoData] = []
    private let db = Firestore.firestore()
    
    // Fetch Short videos only
    func fetchShortVideos() {
        db.collection("video_list").whereField("type", isEqualTo: "Short").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                return
            }
            self.shortVideos = snapshot?.documents.compactMap { doc in
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
    
    // Fetch Long videos only
    func fetchLongVideos() {
        db.collection("video_list").whereField("type", isEqualTo: "Long").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                return
            }
            self.longVideos = snapshot?.documents.compactMap { doc in
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

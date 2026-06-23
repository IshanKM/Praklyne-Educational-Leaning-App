import Foundation
import Combine

// MARK: - Persistence Manager for Liked / Saved Videos
// Uses UserDefaults so state survives app restarts.

final class VideoLibraryStore: ObservableObject {

    static let shared = VideoLibraryStore()   // single source of truth

    // Stored as arrays of video titles (UUID changes every launch, title is stable)
    @Published private(set) var likedTitles: Set<String>
    @Published private(set) var savedTitles: Set<String>

    private let likedKey  = "praklyne.video.liked"
    private let savedKey  = "praklyne.video.saved"

    private init() {
        let ud = UserDefaults.standard
        likedTitles = Set(ud.stringArray(forKey: "praklyne.video.liked") ?? [])
        savedTitles = Set(ud.stringArray(forKey: "praklyne.video.saved") ?? [])
    }

    // MARK: - Like
    func isLiked(_ video: VideoData)  -> Bool { likedTitles.contains(video.title) }
    func isSaved(_ video: VideoData)  -> Bool { savedTitles.contains(video.title) }

    func toggleLike(_ video: VideoData) {
        if likedTitles.contains(video.title) {
            likedTitles.remove(video.title)
        } else {
            likedTitles.insert(video.title)
        }
        persist()
    }

    func toggleSave(_ video: VideoData) {
        if savedTitles.contains(video.title) {
            savedTitles.remove(video.title)
        } else {
            savedTitles.insert(video.title)
        }
        persist()
    }

    func removeLiked(title: String) {
        likedTitles.remove(title)
        persist()
    }

    func removeSaved(title: String) {
        savedTitles.remove(title)
        persist()
    }

    private func persist() {
        let ud = UserDefaults.standard
        ud.set(Array(likedTitles), forKey: likedKey)
        ud.set(Array(savedTitles), forKey: savedKey)
    }
}

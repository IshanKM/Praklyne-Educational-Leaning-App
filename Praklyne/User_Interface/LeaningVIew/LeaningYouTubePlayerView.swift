import SwiftUI
import WebKit

// MARK: - Learning View YouTube Player
//
// ✅ FIX for "This video is unavailable" Error 152-4:
// Uses youtube-nocookie.com with custom Referer/Origin headers and Safari User-Agent
// to bypass YouTube's embed security policy (same fix as VideoPlayer.swift).
struct LearningYouTubeVideoPlayer: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsAirPlayForMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        // Give it a clean Safari identity string
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !videoID.isEmpty else { return }

        // Avoid reloading the same video
        if uiView.accessibilityIdentifier == videoID { return }
        uiView.accessibilityIdentifier = videoID

        // Point directly to the secure nocookie web endpoint URL structure
        let urlString = "https://www.youtube-nocookie.com/embed/\(videoID)?playsinline=1&rel=0&modestbranding=1&controls=1&enablejsapi=1"

        guard let url = URL(string: urlString) else { return }

        // THE FIX: Send app bundle identifier signature as the security referer domain
        var request = URLRequest(url: url)
        request.setValue("https://com.Praklyne.Educational.App", forHTTPHeaderField: "Referer")
        request.setValue("https://com.Praklyne.Educational.App", forHTTPHeaderField: "Origin")

        uiView.load(request)
    }
}

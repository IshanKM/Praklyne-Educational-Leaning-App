import SwiftUI
import WebKit

struct LLearningYouTubeVideoPlayer: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <html><body style="margin:0;">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=0&controls=1" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
        </body></html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

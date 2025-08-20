import SwiftUI
import WebKit

struct VideoPlayer: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        let view = WKWebView(frame: .zero, configuration: config)
        view.scrollView.isScrollEnabled = false
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let html = """
        <html><body style="margin:0;">
        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)?playsinline=1&autoplay=1&mute=1&controls=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
        </body></html>
        """
        uiView.loadHTMLString(html, baseURL: nil)
    }
}

import SwiftUI
import WebKit

struct YouTubePlayerVideoView: UIViewRepresentable {
    let videoID: String
    let isMuted: Bool

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        
        // 1. Give it a clean Safari identity string
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !videoID.isEmpty else { return }

        // If video is already loaded, handle dynamic muting changes instantly
        if uiView.accessibilityIdentifier == videoID {
            let command = isMuted ? "mute" : "unMute"
            let js = "document.getElementsByTagName('iframe')[0]?.contentWindow.postMessage(JSON.stringify({'event':'command','func':'\(command)','args':''}), '*');"
            uiView.evaluateJavaScript(js, completionHandler: nil)
            return
        }

        uiView.accessibilityIdentifier = videoID
        let muteValue = isMuted ? 1 : 0
        
        // 2. Point directly to the secure nocookie web endpoint URL structure
        let urlString = "https://www.youtube-nocookie.com/embed/\(videoID)?autoplay=1&mute=\(muteValue)&playsinline=1&rel=0&modestbranding=1&loop=1&playlist=\(videoID)&enablejsapi=1"
        
        guard let url = URL(string: urlString) else { return }
        
        // 3. THE FIXED MATCH: Send your app bundle identifier signature as the security referer domain
        var request = URLRequest(url: url)
        request.setValue("https://com.Praklyne.Educational.App", forHTTPHeaderField: "Referer")
        request.setValue("https://com.Praklyne.Educational.App", forHTTPHeaderField: "Origin")
        
        uiView.load(request)
    }
}

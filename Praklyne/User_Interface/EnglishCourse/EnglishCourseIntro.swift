import SwiftUI
import WebKit

struct CourseIntroView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    videoPlayerSection
                    noticeSection
                    actionButtonSection
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Course Intro")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("English Learning Course")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Master English through Documentary Videos")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 24)
    }
    
    private var videoPlayerSection: some View {
        VStack(spacing: 16) {
            YouTubeIntroPlayerView(videoID: "GUZauFzCyG0")
                .frame(height: 220)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                Text("Course Introduction Video")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Watch this essential introduction to understand how to get the most out of your English learning journey")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 32)
    }
    
    private var noticeSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.red)
            }
            
            VStack(spacing: 16) {
                Text("Important Notice")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Before starting this course, please watch this video and get a clear idea about how to continue this course.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.3), lineWidth: 2)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
    
    private var actionButtonSection: some View {
        VStack(spacing: 16) {
            NavigationLink(destination: CourseProgressView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)) {
                HStack(spacing: 12) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                    Text("Go to the Course")
                        .font(.system(size: 18, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
        }
    }
}



struct YouTubeIntroPlayerView: UIViewRepresentable {
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        config.allowsAirPlayForMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.backgroundColor = .black
        webView.isOpaque = false

        // Give it a clean Safari identity string
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard !videoID.isEmpty else { return }
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


struct CourseIntroView_Previews: PreviewProvider {
    static var previews: some View {
        CourseIntroView()
    }
}

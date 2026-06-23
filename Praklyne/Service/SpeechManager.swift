import Foundation
import AVFoundation

final class SpeechManager: ObservableObject {
    static let shared = SpeechManager()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() {}
    
    func speak(_ text: String, rate: Double) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        // Attempt to find a high-quality English voice
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        // Ensure rate is bounded between min and max speech rates
        let boundedRate = Float(rate).clamped(
            to: AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate
        )
        utterance.rate = boundedRate
        
        synthesizer.speak(utterance)
    }
    
    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

// Helper extension to clamp speech rate
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

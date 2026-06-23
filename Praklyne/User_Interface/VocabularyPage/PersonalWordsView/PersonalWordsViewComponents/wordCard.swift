import SwiftUI

struct WordCard: View {
    let word: VocabularyWord
    let isLearned: Bool
    let onToggleLearned: () -> Void
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(word.english)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        let rate = UserDefaults.standard.double(forKey: "speech_rate")
                        let rateVal = rate > 0 ? rate : 0.5
                        SpeechManager.shared.speak(word.english, rate: rateVal)
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.orange)
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { level in
                            Circle()
                                .fill(level <= word.difficulty ? Color.orange : Color.gray.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                }
                
                Text(word.sinhala)
                    .font(.body)
                    .foregroundColor(.gray)
                
                Text(word.category.uppercased())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            }
            
            
            Button(action: onToggleLearned) {
                Image(systemName: isLearned ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(isLearned ? .green : .gray)
            }
            
      
            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

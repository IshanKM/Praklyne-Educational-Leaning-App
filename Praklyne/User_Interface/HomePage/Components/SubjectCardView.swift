import SwiftUI

struct SubjectCardView: View {
    let subject: Subject
    @State private var showTopics = false
    
    var body: some View {
        Button(action: {
            showTopics = true
        }) {
            VStack(spacing: 8) {
                Image(systemName: subject.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .background(subject.color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(subject.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .sheet(isPresented: $showTopics) {
            TopicsListView(subject: subject)
        }
    }
}

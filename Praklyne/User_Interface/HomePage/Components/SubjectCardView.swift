import SwiftUI

struct SubjectCardView: View {
    let subject: Subject
    
    var body: some View {
        NavigationLink(
            destination: TopicsListView(
                learningSubject: LearningSubject(id: subject.id, name: subject.name, color: subject.color)
            )
        ) {
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
    }
}


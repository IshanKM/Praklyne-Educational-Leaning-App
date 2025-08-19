import SwiftUI
import Foundation


struct SubjectCardView: View {
    let subject: Subject
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: subject.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(subject.color)
                .cornerRadius(12)
            
            Text(subject.name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(subject.color)
        .cornerRadius(16)
    }
}

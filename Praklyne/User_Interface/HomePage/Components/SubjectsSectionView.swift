import SwiftUI
import Foundation


struct SubjectsSectionView: View {
    @Binding var showAll: Bool
    
    let subjects = [
        Subject(id: 1, name: "Science", color: .green, icon: "atom"),
        Subject(id: 2, name: "Maths", color: .blue, icon: "function"),
        Subject(id: 3, name: "Programming", color: .pink, icon: "chevron.left.forwardslash.chevron.right"),
        Subject(id: 4, name: "Business", color: .purple, icon: "briefcase.fill"),
        Subject(id: 5, name: "History", color: .orange, icon: "book.closed"),
        Subject(id: 6, name: "Geography", color: .teal, icon: "globe")
    ]
    
   
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            HStack {
                Text("Subjects")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showAll.toggle()
                    }
                }) {
                    Text(showAll ? "Show Less" : "See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            if showAll {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                    ForEach(subjects, id: \.id) { subject in
                        SubjectCardView(subject: subject)
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(subjects.prefix(4), id: \.id) { subject in
                            SubjectCardView(subject: subject)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

import SwiftUI
import Foundation

struct SubjectsSectionView: View {
    @Binding var showAll: Bool

    let subjects = [
        Subject(id: 1, name: "Science",     color: .green,  icon: "atom"),
        Subject(id: 2, name: "Maths",       color: .blue,   icon: "function"),
        Subject(id: 3, name: "Programming", color: .pink,   icon: "chevron.left.forwardslash.chevron.right"),
        Subject(id: 4, name: "Business",    color: .purple, icon: "briefcase.fill"),
        Subject(id: 5, name: "History",     color: .orange, icon: "book.closed"),
        Subject(id: 6, name: "Geography",   color: .teal,   icon: "globe")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: – Section header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Subjects")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Pick a subject to explore")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        showAll.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Text(showAll ? "Show Less" : "See All")
                            .font(.system(size: 13, weight: .semibold))
                        Image(systemName: showAll ? "chevron.up" : "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "#1A73E8").opacity(0.08))
                    .clipShape(Capsule())
                }
            }

            // MARK: – Grid or horizontal scroll
            if showAll {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                    spacing: 20
                ) {
                    ForEach(subjects, id: \.id) { subject in
                        SubjectCardView(subject: subject)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(subjects.prefix(4), id: \.id) { subject in
                            SubjectCardView(subject: subject)
                        }
                    }
                    .padding(.horizontal, 2)
                    .padding(.vertical, 4)
                }
                .transition(.opacity)
            }
        }
    }
}

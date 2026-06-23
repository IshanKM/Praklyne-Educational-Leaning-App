import SwiftUI

struct CoursesSectionView: View {
    let courses = [
        Course(
            id: 1,
            title: "One Month Rapid English Course",
            description: "Improve your English in 30 days with documentaries, reflection, and daily speaking practice",
            duration: "30 hours",
            rating: 4.9,
            image: "english_course_banner"
        )
    ]

    @State private var enrolledCourse: EnrolledCourse? =
        UserDefaults.standard.loadCourse(forKey: "enrolledCourse")
    @State private var navigateToIntro = false
    @State private var navigateToProgress = false
    @State private var currentPage = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // MARK: – Section header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Featured Course")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Start learning today")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }

            // MARK: – Carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(courses.enumerated()), id: \.element.id) { index, course in
                        NavigationLink(
                            destination: UserDefaults.standard.bool(forKey: "hasSeenIntro")
                                ? AnyView(CourseProgressView())
                                : AnyView(
                                    CourseIntroView()
                                        .onDisappear {
                                            UserDefaults.standard.set(true, forKey: "hasSeenIntro")
                                        }
                                ),
                            isActive: UserDefaults.standard.bool(forKey: "hasSeenIntro")
                                ? $navigateToProgress
                                : $navigateToIntro
                        ) {
                            CourseCardView(
                                course: course,
                                enrolledCourse: $enrolledCourse,
                                navigateToIntro: $navigateToIntro,
                                navigateToProgress: $navigateToProgress
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 20)

            // MARK: – Page dots
            if courses.count > 1 {
                HStack(spacing: 6) {
                    ForEach(0..<courses.count, id: \.self) { i in
                        Capsule()
                            .fill(i == currentPage
                                  ? LinearGradient(colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                                                   startPoint: .leading, endPoint: .trailing)
                                  : LinearGradient(colors: [Color(.systemFill)],
                                                   startPoint: .leading, endPoint: .trailing))
                            .frame(width: i == currentPage ? 18 : 6, height: 6)
                            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
            } else {
                // Single card – static dot
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 8, height: 8)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 4)
            }
        }
    }
}

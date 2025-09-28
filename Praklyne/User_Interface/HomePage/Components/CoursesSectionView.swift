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
    
    var body: some View {
        VStack(alignment: .leading) {
           
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(courses, id: \.id) { course in
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
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
          
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
            }
            .frame(maxWidth: .infinity, alignment: .center) 
            .padding(.top, 10)

        }
    }
}

import SwiftUI

struct CourseCardView: View {
    let course: Course
    @Binding var enrolledCourse: EnrolledCourse?
    @Binding var navigateToIntro: Bool
    @Binding var navigateToProgress: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ZStack(alignment: .bottomLeading) {
             
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.25), Color.blue.opacity(0.25)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                
                Image(course.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text(course.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                HStack(spacing: 8) {
                    Label("\(course.rating, specifier: "%.1f")", systemImage: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text(course.duration)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
            
                HStack {
                    Spacer()
                    if enrolledCourse?.id == course.id {
                        Button("Continue") {
                            if UserDefaults.standard.bool(forKey: "hasSeenIntro") {
                                navigateToProgress = true
                            } else {
                                navigateToIntro = true
                            }
                        }
                        .buttonStyle(FilledButtonStyle(background: Color.green))
                    } else {
                        Button("Enroll") {
                            let newCourse = EnrolledCourse(
                                id: course.id,
                                title: course.title,
                                startDate: Date(),
                                completedDays: 0,
                                totalDays: 30
                            )
                            enrolledCourse = newCourse
                            UserDefaults.standard.saveCourse(newCourse, forKey: "enrolledCourse")
                            
                            NotificationManager.shared.sendEnrollmentNotification(for: course.title)
                            
                            navigateToIntro = true
                        }
                        .buttonStyle(FilledButtonStyle(background: Color.blue))
                    }
                    Spacer()
                }
                .padding(.top, 8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
        }
        .frame(width: 320)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 6)
    }
}


struct FilledButtonStyle: ButtonStyle {
    var background: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(background)
            .cornerRadius(25)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}

import SwiftUI

struct CourseCardView: View {
    let course: Course
    @Binding var enrolledCourse: EnrolledCourse?
    @Binding var navigateToIntro: Bool
    @Binding var navigateToProgress: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [Color.green.opacity(0.3), Color.blue.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 180)
                
                Image(course.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(course.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                Text(course.duration)
                    .font(.caption)
                    .foregroundColor(.gray)
                
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
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(20)
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
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(20)
                    }
                    Spacer()
                }
                .padding(.top, 8)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
        }
        .frame(width: 300, height: 320)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        
    }
}

import SwiftUI

struct CourseCardView: View {
    let course: Course
    @Binding var enrolledCourse: EnrolledCourse?
    @Binding var navigateToIntro: Bool
    @Binding var navigateToProgress: Bool

    private var isEnrolled: Bool { enrolledCourse?.id == course.id }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: – Banner image with gradient overlay
            ZStack(alignment: .bottomLeading) {
                Image(course.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 310, height: 170)
                    .clipped()

                // Scrim for text legibility
                LinearGradient(
                    colors: [Color.black.opacity(0.55), Color.clear],
                    startPoint: .bottom,
                    endPoint: .center
                )

                // Rating chip on top-right
                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", course.rating))
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(12)
                    }
                    Spacer()
                }
            }
            .frame(width: 310, height: 170)
            .clipShape(TopRoundedRect(radius: 20))

            // MARK: – Text content
            VStack(alignment: .leading, spacing: 8) {
                Text(course.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                Text(course.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text(course.duration)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }

                // MARK: – Action button
                HStack {
                    Spacer()
                    if isEnrolled {
                        Button("Continue Learning") {
                            if UserDefaults.standard.bool(forKey: "hasSeenIntro") {
                                navigateToProgress = true
                            } else {
                                navigateToIntro = true
                            }
                        }
                        .buttonStyle(PremiumButtonStyle(gradient: [Color(hex: "#34C759"), Color(hex: "#30D158")]))
                    } else {
                        Button("Enroll Now") {
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
                        .buttonStyle(PremiumButtonStyle(gradient: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")]))
                    }
                    Spacer()
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .frame(width: 310)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.10), radius: 16, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(.separator).opacity(0.3), lineWidth: 0.5)
        )
    }
}

// MARK: - Premium Button Style
struct PremiumButtonStyle: ButtonStyle {
    var gradient: [Color]

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 11)
            .background(
                LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
            .shadow(color: gradient.first?.opacity(0.4) ?? .clear, radius: 8, x: 0, y: 4)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Legacy style kept for compatibility
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

// MARK: - Custom shape: rounds only the top corners (iOS 16 compatible)
struct TopRoundedRect: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = min(radius, rect.height / 2, rect.width / 2)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + r, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + r),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

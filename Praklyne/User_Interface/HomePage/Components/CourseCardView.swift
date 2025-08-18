import SwiftUI
import Foundation


struct CourseCardView: View {
    let course: Course
    
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
                
      
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
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
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("\(course.rating, specifier: "%.1f")")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Text("Enroll")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

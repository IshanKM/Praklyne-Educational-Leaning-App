// EnrolledCourse.swift
import Foundation

struct EnrolledCourse: Codable, Identifiable {
    let id: Int
    let title: String
    var startDate: Date
    var completedDays: Int
    var totalDays: Int
}

// MARK: - UserDefaults Helpers
extension UserDefaults {
    func saveCourse(_ course: EnrolledCourse, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(course) {
            self.set(encoded, forKey: key)
        }
    }
    
    func loadCourse(forKey key: String) -> EnrolledCourse? {
        if let data = self.data(forKey: key),
           let decoded = try? JSONDecoder().decode(EnrolledCourse.self, from: data) {
            return decoded
        }
        return nil
    }
}

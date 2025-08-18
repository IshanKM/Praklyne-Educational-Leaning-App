import SwiftUI
import Foundation
import FirebaseAuth

struct UserModel {
    var uid: String
    var email: String?
    var displayName: String?
    var photoURL: String?   

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL?.absoluteString
    }
}

import Foundation
import FirebaseAuth

struct UserModel {
    var uid: String
    var email: String?
    var displayName: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.displayName = user.displayName
    }
}

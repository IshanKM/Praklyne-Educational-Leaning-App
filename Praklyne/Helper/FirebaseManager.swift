import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import AuthenticationServices
import SwiftUI
import CryptoKit

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Save User to Firestore (called after every login)
    // This is what makes the user appear in the Admin Dashboard "Users" section.
    func saveUserToFirestore(_ authResult: AuthDataResult) {
        let user = authResult.user
        let userData: [String: Any] = [
            "uid":         user.uid,
            "email":       user.email ?? "",
            "displayName": user.displayName ?? "",
            "photoURL":    user.photoURL?.absoluteString ?? "",
            "createdAt":   FieldValue.serverTimestamp()
        ]
        // merge: true — updates existing users without deleting any extra fields
        db.collection("users")
            .document(user.uid)
            .setData(userData, merge: true) { error in
                if let error = error {
                    print("❌ Failed to save user to Firestore: \(error.localizedDescription)")
                } else {
                    print("✅ User saved to Firestore: \(user.email ?? user.uid)")
                    CloudSyncManager.shared.restoreUserData {}
                }
            }
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle(completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let accessToken = user.accessToken.tokenString
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let authResult = authResult {
                    // ✅ Save user data to Firestore so Admin Dashboard shows them
                    self.saveUserToFirestore(authResult)
                    completion(.success(authResult))
                }
            }
        }
    }

    // MARK: - Apple Sign In Cryptographic Nonce Helpers
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let err = SecRandomCopyBytes(kSecRandomDefault, length, &randomBytes)
        if err != errSecSuccess {
            fatalError("Unable to generate input bytes: \(err)")
        }

        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    // MARK: - Apple Sign In
    func signInWithApple(credential: ASAuthorizationAppleIDCredential, rawNonce: String?, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else { return }

        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: rawNonce
        )

        Auth.auth().signIn(with: firebaseCredential) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let authResult = authResult {
                // ✅ Save user data to Firestore so Admin Dashboard shows them
                self.saveUserToFirestore(authResult)
                completion(.success(authResult))
            }
        }
    }
}

import LocalAuthentication
import SwiftUI
import Combine

class LockManager: ObservableObject {
    @Published var isLocked: Bool = true
    @Published var requiresPIN: Bool = false
    @Published var faceIDError: String? = nil
    @Published var failedAttempts: Int = 0
    

    private var lockTimeout: Date? {
        get {
            if let interval = UserDefaults.standard.value(forKey: "lockTimeout") as? TimeInterval {
                return Date(timeIntervalSince1970: interval)
            }
            return nil
        }
        set {
            if let date = newValue {
                UserDefaults.standard.set(date.timeIntervalSince1970, forKey: "lockTimeout")
            } else {
                UserDefaults.standard.removeObject(forKey: "lockTimeout")
            }
        }
    }
    
    @Published var storedPIN: String? = UserDefaults.standard.string(forKey: "appPIN")
    @Published var pinEnabled: Bool = UserDefaults.standard.bool(forKey: "pinEnabled")
    @Published var faceIDEnabled: Bool = UserDefaults.standard.bool(forKey: "faceIDEnabled")
    
    let maxAttempts = 5
    let timeoutSeconds: TimeInterval = 120
    
    func autoCheckFaceID() {
        guard faceIDEnabled else {
            requiresPIN = true
            return
        }
        
    
        if let timeout = lockTimeout, Date() < timeout {
            faceIDError = "App locked. Try again later."
            requiresPIN = true
            return
        }
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            requiresPIN = true
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: "Unlock the app") { success, authError in
            DispatchQueue.main.async {
                if success {
                    self.isLocked = false
                    self.failedAttempts = 0
                    self.faceIDError = nil
                } else {
                    self.failedAttempts += 1
                    self.requiresPIN = true
                    self.faceIDError = "Face ID not recognized. Attempts left: \(self.maxAttempts - self.failedAttempts)"
                    
                    if self.failedAttempts >= self.maxAttempts {
                        self.lockTimeout = Date().addingTimeInterval(self.timeoutSeconds)
                        self.failedAttempts = 0
                        self.faceIDError = "Too many attempts. App locked for 2 min."
                    }
                }
            }
        }
    }
    

    func verifyPIN(_ pin: String) -> Bool {
    
        if let timeout = lockTimeout, Date() < timeout {
            faceIDError = "App is locked. Try again later."
            return false
        }
        

        guard let stored = storedPIN, !stored.isEmpty else {
            isLocked = false
            requiresPIN = false
            return true
        }

        if pin == stored {
            isLocked = false
            failedAttempts = 0
            faceIDError = nil
            return true
        } else {
            failedAttempts += 1
            let remaining = maxAttempts - failedAttempts
            if failedAttempts >= maxAttempts {
                lockTimeout = Date().addingTimeInterval(timeoutSeconds)
                failedAttempts = 0
                faceIDError = "Too many failed attempts. Try again in 2 minutes."
            } else {
                faceIDError = "Incorrect PIN. Attempts left: \(remaining)"
            }
            return false
        }
    }
    

    func savePIN(_ pin: String) {
        storedPIN = pin
        UserDefaults.standard.set(pin, forKey: "appPIN")
    }
    
    func toggleFaceID(_ enabled: Bool) {
        faceIDEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "faceIDEnabled")
        if enabled { autoCheckFaceID() }
    }
    
    func togglePIN(_ enabled: Bool) {
        pinEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "pinEnabled")
    }
}

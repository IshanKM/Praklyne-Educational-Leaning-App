import SwiftUI

struct RootView: View {
    @StateObject var lockManager = LockManager()
    @Binding var user: UserModel?
    @State private var selectedTab: Int = 0
    @StateObject private var onboardingManager = OnboardingManager()
    
    var body: some View {
        ZStack {
            if lockManager.isLocked {
                if lockManager.requiresPIN || lockManager.pinEnabled {
                    PINEntryView(lockManager: lockManager)
                } else if lockManager.faceIDEnabled {
                    Text("Unlocking...")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .onAppear {
                            lockManager.autoCheckFaceID()
                        }
                } else {
                    // No PIN or FaceID -> unlock automatically
                    Text("Welcome!")
                        .onAppear {
                            lockManager.isLocked = false
                        }
                }
            } else {
                if onboardingManager.hasCompletedOnboarding {
                    MainTabNavigationView(
                        selectedTab: $selectedTab,
                        user: $user,
                        lockManager: lockManager
                    )
                } else {
                    OnboardingView {
                        onboardingManager.completeOnboarding()
                    }
                }
            }
        }
    }
}

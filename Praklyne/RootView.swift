import SwiftUI

struct RootView: View {
    @StateObject var lockManager = LockManager()
    @Binding var user: UserModel?
    @State private var selectedTab: Int = 0
    @StateObject private var onboardingManager = OnboardingManager()
    
    var body: some View {
        ZStack {
            if lockManager.isLocked {
                if lockManager.requiresPIN {
                    PINEntryView(lockManager: lockManager)
                } else {
                    Text("Unlocking...")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .onAppear {
                            lockManager.autoCheckFaceID()
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

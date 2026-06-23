
import SwiftUI

struct HomeView: View {
    @Binding var user: UserModel?
    @Binding var selectedTab: Int

    @State private var selectedToolsTab = "English"
    @State private var showAllSubjects = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // Header – avatar, greeting, notification
                    HeaderView(user: user, selectedTab: $selectedTab)
                        .padding(.horizontal, 16)

                    // Featured Course carousel
                    CoursesSectionView()
                        .padding(.horizontal, 16)

                    // Divider
                    Divider()
                        .padding(.horizontal, 16)

                    // Subjects grid / horizontal scroll
                    SubjectsSectionView(showAll: $showAllSubjects)
                        .padding(.horizontal, 16)

                    // Divider
                    Divider()
                        .padding(.horizontal, 16)

                    // Tools with category tabs
                    ToolsSectionView(selectedTab: $selectedToolsTab)
                        .padding(.horizontal, 16)

                    Spacer(minLength: 100)
                }
                .padding(.top, 4)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var previewUser: UserModel? = nil

    static var previews: some View {
        HomeView(user: $previewUser, selectedTab: .constant(0))
    }
}

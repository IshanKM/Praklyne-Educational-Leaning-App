import SwiftUI

struct HomeView: View {
    @Binding var user: UserModel?
    
    @State private var selectedToolsTab = "English"
    @State private var showAllSubjects = false
    @State private var selectedBottomTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    HeaderView(user: user)
                    
                    CoursesSectionView()
                  
                    SubjectsSectionView(showAll: $showAllSubjects)
                    
                    Spacer()
                    
                    ToolsSectionView(selectedTab: $selectedToolsTab)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
            .background(Color(.systemBackground))
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var previewUser: UserModel? = nil

    static var previews: some View {
        HomeView(user: $previewUser)
    }
}


import SwiftUI

struct HomeView: View {
    @State private var selectedToolsTab = "English"
    @State private var showAllSubjects = false
    @State private var selectedBottomTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    HeaderView()
                    
                    CoursesSectionView()
                  
                    SubjectsSectionView(showAll: $showAllSubjects)
                    
                    ToolsSectionView(selectedTab: $selectedToolsTab)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
            }
            .background(Color(.systemBackground))
        }
        .overlay(
   
            BottomNavigationView(selectedTab: $selectedBottomTab)
                .background(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2),
            alignment: .bottom
        )
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

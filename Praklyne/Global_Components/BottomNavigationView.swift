import SwiftUI
import Foundation


struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        (icon: "house.fill", title: "Home"),
        (icon: "magnifyingglass", title: "Search"),
        (icon: "play.rectangle.fill", title: "Video"),
        (icon: "clock.fill", title: "History"),
        (icon: "person.fill", title: "Profile")
    ]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == index ? .blue : .gray)
                        
                        Text(tabs[index].title)
                            .font(.caption2)
                            .foregroundColor(selectedTab == index ? .blue : .gray)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
        .background(Color.white)
    }
}

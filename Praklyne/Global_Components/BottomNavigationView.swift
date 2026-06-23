import SwiftUI
import Foundation

struct BottomNavigationView: View {
    @Binding var selectedTab: Int
    @StateObject private var library = VideoLibraryStore.shared

    let tabs: [(icon: String, activeIcon: String, title: String)] = [
        (icon: "house",                  activeIcon: "house.fill",                  title: "Home"),
        (icon: "magnifyingglass",        activeIcon: "magnifyingglass",             title: "Search"),
        (icon: "play.rectangle",         activeIcon: "play.rectangle.fill",         title: "Video"),
        (icon: "bookmark",               activeIcon: "bookmark.fill",               title: "Library"),
        (icon: "person",                 activeIcon: "person.fill",                 title: "Profile")
    ]

    // Badge count for the Library tab
    private var libraryBadge: Int {
        library.likedTitles.count + library.savedTitles.count
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: selectedTab == index ? tabs[index].activeIcon : tabs[index].icon)
                                .font(.system(size: 20, weight: selectedTab == index ? .semibold : .regular))
                                .foregroundColor(selectedTab == index ? Color(hex: "#1A73E8") : .gray)
                                .scaleEffect(selectedTab == index ? 1.1 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedTab)

                            // Badge on Library tab
                            if index == 3 && libraryBadge > 0 {
                                Text(libraryBadge > 99 ? "99+" : "\(libraryBadge)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                                    .offset(x: 10, y: -6)
                            }
                        }

                        Text(tabs[index].title)
                            .font(.system(size: 10, weight: selectedTab == index ? .semibold : .regular))
                            .foregroundColor(selectedTab == index ? Color(hex: "#1A73E8") : .gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.bottom, 2)
        .background(Color.white)
    }
}

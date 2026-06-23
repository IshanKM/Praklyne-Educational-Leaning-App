import SwiftUI
import UserNotifications

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var store = NotificationHistoryStore.shared
    
    var body: some View {
        ZStack {
            // ── Premium Ambient Background ──
            ambientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ── Toolbar Header ──
                customNavigationBar
                
                if store.items.isEmpty {
                    // ── Empty State ──
                    emptyStateView
                } else {
                    // ── Active Notifications List ──
                    notificationsList
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            store.syncWithSystemDeliveredNotifications()
            store.markAllAsRead()
        }
    }
    
    // MARK: - Subviews
    
    private var ambientBackground: some View {
        Color(colorScheme == .dark ? Color(hex: "#0A0F1D") : Color(hex: "#F8FAFC"))
    }
    
    private var customNavigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.04))
                        .frame(width: 40, height: 40)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
            
            Text("Notifications")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
            
            if !store.items.isEmpty {
                Button(action: {
                    withAnimation {
                        store.clearAll()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Clear")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.08))
                    )
                }
            } else {
                Spacer()
                    .frame(width: 40) // Balance spacing
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            colorScheme == .dark ? Color(hex: "#0A0F1D") : Color(hex: "#F8FAFC")
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#10B981").opacity(0.12), Color(hex: "#6C63FF").opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                
                Image(systemName: "bell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#10B981"), Color(hex: "#6C63FF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(hex: "#10B981").opacity(0.3), radius: 10, x: 0, y: 5)
            }
            
            VStack(spacing: 8) {
                Text("All Caught Up!")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("You currently have no new notifications.\nCheck back later for reminders and vocabulary tasks.")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
    
    private var notificationsList: some View {
        List {
            ForEach(store.items) { item in
                NotificationRowView(item: item)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            }
            .onDelete(perform: store.deleteItem)
        }
        .listStyle(.plain)
        .background(Color.clear)
    }
}

// MARK: - Notification Row Card
struct NotificationRowView: View {
    let item: NotificationItem
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Badge themed by content title
            ZStack {
                Circle()
                    .fill(badgeGradient)
                    .frame(width: 44, height: 44)
                
                Image(systemName: badgeIcon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
            }
            .shadow(color: badgeColor.opacity(0.3), radius: 6, x: 0, y: 3)
            
            // Text Details
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(item.title)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(timeAgo(from: item.date))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                
                Text(item.body)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .lineSpacing(2)
            }
            
            // Unread dot tracking
            if !item.isRead {
                Circle()
                    .fill(Color(hex: "#1A73E8"))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(colorScheme == .dark ? Color(hex: "#1E293B").opacity(0.85) : Color.white)
                .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.03), radius: 6, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.02),
                    lineWidth: 1
                )
        )
    }
    
    // MARK: - Helpers
    
    private var badgeIcon: String {
        let title = item.title.lowercased()
        if title.contains("enrolled") { return "checkmark.seal.fill" }
        if title.contains("vocab") || title.contains("word") { return "book.closed.fill" }
        if title.contains("daily") || title.contains("practice") { return "calendar.badge.clock" }
        return "bell.fill"
    }
    
    private var badgeColor: Color {
        let title = item.title.lowercased()
        if title.contains("enrolled") { return Color(hex: "#10B981") } // green
        if title.contains("vocab") || title.contains("word") { return Color(hex: "#6C63FF") } // purple
        if title.contains("daily") || title.contains("practice") { return Color(hex: "#F59E0B") } // orange
        return Color(hex: "#1A73E8") // blue
    }
    
    private var badgeGradient: LinearGradient {
        let colors: [Color]
        let title = item.title.lowercased()
        if title.contains("enrolled") {
            colors = [Color(hex: "#10B981"), Color(hex: "#059669")]
        } else if title.contains("vocab") || title.contains("word") {
            colors = [Color(hex: "#6C63FF"), Color(hex: "#B19FFB")]
        } else if title.contains("daily") || title.contains("practice") {
            colors = [Color(hex: "#F59E0B"), Color(hex: "#D97706")]
        } else {
            colors = [Color(hex: "#1A73E8"), Color(hex: "#00C6FF")]
        }
        
        return LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func timeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            if day == 1 { return "Yesterday" }
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .none
            return formatter.string(from: date)
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour)h ago"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute)m ago"
        }
        return "Just now"
    }
}

// MARK: - Previews
struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}

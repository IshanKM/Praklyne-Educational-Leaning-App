import SwiftUI
import Foundation

struct ToolsSectionView: View {
    @Binding var selectedTab: String
    let tabs = ["English", "Science", "Maths", "Business"]
    @Namespace private var tabNamespace

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: – Section header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tools")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    Text("Pick your learning tools")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }

            // MARK: – Tab bar (pill style)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                selectedTab = tab
                            }
                        }) {
                            Text(tab)
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(selectedTab == tab ? .white : .secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background {
                                    if selectedTab == tab {
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    colors: [Color(hex: "#1A73E8"), Color(hex: "#6C63FF")],
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .matchedGeometryEffect(id: "tab", in: tabNamespace)
                                            .shadow(color: Color(hex: "#1A73E8").opacity(0.35), radius: 6, x: 0, y: 3)
                                    } else {
                                        Capsule()
                                            .fill(Color(.systemFill))
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 4)
            }

            // MARK: – Tools list (vertical rows)
            VStack(spacing: 10) {
                ForEach(getToolsForTab(selectedTab), id: \.id) { tool in
                    ToolCardView(tool: tool)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
    }

    func getToolsForTab(_ tab: String) -> [Tool] {
        switch tab {
        case "English":
            return [
                Tool(id: 1, name: "Your vocabulary list", icon: "book.fill",             color: .orange),
                Tool(id: 2, name: "Learning with AI",     icon: "brain.head.profile",    color: .blue),
                Tool(id: 3, name: "Listing Content",      icon: "headphones",            color: .green),
                Tool(id: 4, name: "Books",                icon: "books.vertical.fill",   color: .purple)
            ]
        case "Science":
            return [
                Tool(id: 5, name: "Lab Experiments",  icon: "flask.fill",          color: .red),
                Tool(id: 6, name: "Periodic Table",   icon: "atom",                color: .blue),
                Tool(id: 7, name: "Physics Simulator",icon: "waveform",            color: .green),
                Tool(id: 8, name: "Chemistry Guide",  icon: "testtube.2",          color: .orange)
            ]
        case "Maths":
            return [
                Tool(id: 9,  name: "Calculator",     icon: "function",                    color: .blue),
                Tool(id: 10, name: "Geometry Tools", icon: "triangle.fill",               color: .green),
                Tool(id: 11, name: "Graph Plotter",  icon: "chart.line.uptrend.xyaxis",   color: .purple),
                Tool(id: 12, name: "Formula Bank",   icon: "x.squareroot",               color: .orange)
            ]
        case "Business":
            return [
                Tool(id: 13, name: "Market Analysis", icon: "chart.bar.fill",          color: .blue),
                Tool(id: 14, name: "Finance Tracker", icon: "dollarsign.circle.fill",  color: .green),
                Tool(id: 15, name: "Business Plans",  icon: "briefcase.fill",          color: .purple),
                Tool(id: 16, name: "Networking",      icon: "person.2.fill",           color: .orange)
            ]
        default:
            return []
        }
    }
}

import SwiftUI
import Foundation


struct ToolsSectionView: View {
    @Binding var selectedTab: String
    let tabs = ["English", "Science", "Maths", "Business"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tools")
                .font(.title2)
                .fontWeight(.semibold)
            
 
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    ForEach(tabs, id: \.self) { tab in
                        VStack(spacing: 8) {
                            Text(tab)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedTab == tab ? .blue : .gray)
                            
                            Rectangle()
                                .fill(selectedTab == tab ? Color.blue : Color.clear)
                                .frame(height: 2)
                        }
                        .onTapGesture {
                            selectedTab = tab
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
     
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(getToolsForTab(selectedTab), id: \.id) { tool in
                    ToolCardView(tool: tool)
                }
            }
        }
    }
    
    func getToolsForTab(_ tab: String) -> [Tool] {
        switch tab {
        case "English":
            return [
                Tool(id: 1, name: "Your vocabulary list", icon: "book.fill", color: .orange),
                Tool(id: 2, name: "Learning with AI", icon: "brain.head.profile", color: .blue),
                Tool(id: 3, name: "Listing Content", icon: "headphones", color: .green),
                Tool(id: 4, name: "English Books", icon: "books.vertical.fill", color: .purple)
            ]
        case "Science":
            return [
                Tool(id: 5, name: "Lab Experiments", icon: "flask.fill", color: .red),
                Tool(id: 6, name: "Periodic Table", icon: "atom", color: .blue),
                Tool(id: 7, name: "Physics Simulator", icon: "waveform", color: .green),
                Tool(id: 8, name: "Chemistry Guide", icon: "testtube.2", color: .orange)
            ]
        case "Maths":
            return [
                Tool(id: 9, name: "Calculator", icon: "function", color: .blue),
                Tool(id: 10, name: "Geometry Tools", icon: "triangle.fill", color: .green),
                Tool(id: 11, name: "Graph Plotter", icon: "chart.line.uptrend.xyaxis", color: .purple),
                Tool(id: 12, name: "Formula Bank", icon: "x.squareroot", color: .orange)
            ]
        case "Business":
            return [
                Tool(id: 13, name: "Market Analysis", icon: "chart.bar.fill", color: .blue),
                Tool(id: 14, name: "Finance Tracker", icon: "dollarsign.circle.fill", color: .green),
                Tool(id: 15, name: "Business Plans", icon: "briefcase.fill", color: .purple),
                Tool(id: 16, name: "Networking", icon: "person.2.fill", color: .orange)
            ]
        default:
            return []
        }
    }
}



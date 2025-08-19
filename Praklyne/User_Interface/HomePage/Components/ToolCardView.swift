import SwiftUI
import Foundation


struct ToolCardView: View {
    let tool: Tool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: tool.icon)
                .font(.system(size: 24))
                .foregroundColor(tool.color)
                .frame(width: 50, height: 50)
                .background(tool.color.opacity(0.1))
                .cornerRadius(12)
            
            Text(tool.name)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

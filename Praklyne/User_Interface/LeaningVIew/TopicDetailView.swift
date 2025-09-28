import SwiftUI

struct TopicDetailView: View {
    let topic: Topic
    let subjectColor: Color
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("What is \(topic.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                    
                    Text(topic.description)
                        .font(.body)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                
                // Tabs
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Button(action: { selectedTab = 0 }) {
                            Text("Videos")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedTab == 0 ? .white : subjectColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == 0 ? subjectColor : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Button(action: { selectedTab = 1 }) {
                            Text("Images")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(selectedTab == 1 ? .white : subjectColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(selectedTab == 1 ? subjectColor : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    
                    // Tab Content
                    if selectedTab == 0 {
                        LazyVStack(spacing: 12) {
                            ForEach(topic.videos) { video in
                                VideoRowViewSubject(video: video, subjectColor: subjectColor)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                            ForEach(Array(repeating: "", count: 6), id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemGray5))
                                    .frame(height: 100)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
                
                Spacer(minLength: 100)
            }
        }
        .navigationTitle(topic.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

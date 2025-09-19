import SwiftUI


struct TopicsListView: View {
    let subject: Subject
    @Environment(\.dismiss) private var dismiss
    
   
    var topics: [Topic] {
        let allTopics = [
           
            Topic(id: 1, name: "Electricity", subject: "Science", description: "Learn about electric current, voltage, and circuits", videoUrl: "https://www.youtube.com/watch?v=mc979OhitAg"),
            Topic(id: 2, name: "Gravitation", subject: "Science", description: "Understanding gravity and its effects", videoUrl: "https://www.youtube.com/watch?v=7gf6YpdvtE0"),
            Topic(id: 3, name: "Oscillation", subject: "Science", description: "Study of periodic motion and waves", videoUrl: "https://www.youtube.com/watch?v=qJLFjWqxTmw"),
            Topic(id: 4, name: "Magnetic Fields", subject: "Science", description: "Explore magnetism and electromagnetic fields", videoUrl: "https://www.youtube.com/watch?v=hFAOXdXZ5TM"),
            Topic(id: 5, name: "Thermodynamics", subject: "Science", description: "Heat, temperature, and energy transfer", videoUrl: "https://www.youtube.com/watch?v=NyOYW07-L5g"),
        
            Topic(id: 6, name: "Algebra", subject: "Maths", description: "Variables, equations, and expressions", videoUrl: "https://www.youtube.com/watch?v=NybHckSEQBI"),
            Topic(id: 7, name: "Geometry", subject: "Maths", description: "Shapes, angles, and spatial relationships", videoUrl: "https://www.youtube.com/watch?v=g1ib43q3uXQ"),
            Topic(id: 8, name: "Calculus", subject: "Maths", description: "Derivatives, integrals, and limits", videoUrl: "https://www.youtube.com/watch?v=WUvTyaaNkzM"),
            Topic(id: 9, name: "Statistics", subject: "Maths", description: "Data analysis and probability", videoUrl: "https://www.youtube.com/watch?v=uhxtUt_-GyM"),
            
         
            Topic(id: 10, name: "Swift Basics", subject: "Programming", description: "Introduction to Swift programming language", videoUrl: "https://www.youtube.com/watch?v=Ulp1Kimblg0"),
            Topic(id: 11, name: "Data Structures", subject: "Programming", description: "Arrays, lists, and algorithms", videoUrl: "https://www.youtube.com/watch?v=RBSGKlAvoiM"),
            Topic(id: 12, name: "Object-Oriented Programming", subject: "Programming", description: "Classes, objects, and inheritance", videoUrl: "https://www.youtube.com/watch?v=pTB0EiLXUC8"),
            
       
            Topic(id: 13, name: "Marketing", subject: "Business", description: "Strategies for promoting products and services", videoUrl: "https://www.youtube.com/watch?v=Gjnup-PuquQ"),
            Topic(id: 14, name: "Finance", subject: "Business", description: "Money management and investment principles", videoUrl: "https://www.youtube.com/watch?v=WEDIj9JBTC8"),
            Topic(id: 15, name: "Leadership", subject: "Business", description: "Managing teams and organizations", videoUrl: "https://www.youtube.com/watch?v=llKvV8_T95M"),
            
        
            Topic(id: 16, name: "World War II", subject: "History", description: "Major events and consequences of WWII", videoUrl: "https://www.youtube.com/watch?v=_uk_6vfqwTA"),
            Topic(id: 17, name: "Ancient Civilizations", subject: "History", description: "Egypt, Greece, and Rome", videoUrl: "https://www.youtube.com/watch?v=Z3Wvw6BuQvE"),
            Topic(id: 18, name: "Industrial Revolution", subject: "History", description: "Technological and social changes", videoUrl: "https://www.youtube.com/watch?v=zhL5DCizj5c"),
            
         
            Topic(id: 19, name: "Climate Change", subject: "Geography", description: "Environmental impacts and solutions", videoUrl: "https://www.youtube.com/watch?v=dcC5RFyUd_0"),
            Topic(id: 20, name: "World Capitals", subject: "Geography", description: "Major cities and their significance", videoUrl: "https://www.youtube.com/watch?v=x88Z5txBc7w"),
            Topic(id: 21, name: "Natural Resources", subject: "Geography", description: "Earth's resources and their distribution", videoUrl: "https://www.youtube.com/watch?v=jqxENMKaeCU")
        ]
        
        return allTopics.filter { $0.subject == subject.name }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(topics) { topic in
                        TopicRowView(topic: topic, subjectColor: subject.color)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(subject.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TopicRowView: View {
    let topic: Topic
    let subjectColor: Color
    @State private var showTopicDetail = false
    
    var body: some View {
        Button(action: {
            showTopicDetail = true
        }) {
            HStack(spacing: 16) {
            
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundColor(subjectColor)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(topic.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(topic.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $showTopicDetail) {
            TopicDetailView(topic: topic, subjectColor: subjectColor)
        }
    }
}

struct TopicDetailView: View {
    let topic: Topic
    let subjectColor: Color
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
  
    var theoryContent: String {
        switch topic.name {
        case "Oscillation":
            return "The process of recurring changes of any quantity or measure about its equilibrium value in time is known as oscillation. A periodic change of a matter between two values or around its central value is also known as oscillation.\n\nOscillations occur not only in mechanical systems but also in dynamic systems in virtually every area of science: for example the beating of the human heart (for circulation), business cycles in economics, predator–prey population cycles in ecology, geothermal geysers in geology, vibration of strings in guitar and other string instruments, periodic firing of nerve cells in the brain, and the periodic swelling of Cepheid variable stars in astronomy."
        case "Electricity":
            return "Electricity is the set of physical phenomena associated with the presence and motion of matter that has a property of electric charge. Electricity is related to magnetism, both being part of the phenomenon of electromagnetism, as described by Maxwell's equations."
        case "Gravitation":
            return "Gravitation is a natural phenomenon by which all things with mass or energy are brought toward one another. On Earth, gravity gives weight to physical objects, and the Moon's gravity causes the ocean tides."
        default:
            return "This topic covers fundamental concepts in \(topic.subject.lowercased()). Learn about the key principles, applications, and real-world examples that will help you understand this important subject matter."
        }
    }
    
  
    var videos: [TopicVideo] {
        return [
            TopicVideo(id: 1, title: "Introduction to \(topic.name)", duration: "10:30", thumbnailUrl: ""),
            TopicVideo(id: 2, title: "\(topic.name) Fundamentals", duration: "15:45", thumbnailUrl: ""),
            TopicVideo(id: 3, title: "Advanced \(topic.name)", duration: "20:15", thumbnailUrl: ""),
            TopicVideo(id: 4, title: "\(topic.name) Applications", duration: "12:20", thumbnailUrl: "")
        ]
    }
    
  
    var images: [String] {
        return [
            "/placeholder.svg?height=120&width=120",
            "/placeholder.svg?height=120&width=120",
            "/placeholder.svg?height=120&width=120",
            "/placeholder.svg?height=120&width=120",
            "/placeholder.svg?height=120&width=120",
            "/placeholder.svg?height=120&width=120"
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
         
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                AsyncImage(url: URL(string: "/placeholder.svg?height=150&width=200")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 40))
                                        .foregroundColor(subjectColor)
                                }
                                Text(topic.subject)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 8)
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
              
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What is \(topic.name)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)
                        
                        Text(theoryContent)
                            .font(.body)
                            .lineSpacing(4)
                            .padding(.horizontal, 20)
                    }
                    
                 
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
                        
             
                        if selectedTab == 0 {
                      
                            LazyVStack(spacing: 12) {
                                ForEach(videos) { video in
                                    VideoRowViewSubject(video: video, subjectColor: subjectColor)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        } else {
                        
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                                ForEach(images.indices, id: \.self) { index in
                                    AsyncImage(url: URL(string: images[index])) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.systemGray5))
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(.secondary)
                                            )
                                    }
                                    .frame(height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct VideoRowViewSubject: View {
    let video: TopicVideo
    let subjectColor: Color
    @State private var showVideoPlayer = false
    
    var body: some View {
        Button(action: {
            showVideoPlayer = true
        }) {
            HStack(spacing: 12) {
           
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 60)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.title2)
                            .foregroundColor(subjectColor)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(video.duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .sheet(isPresented: $showVideoPlayer) {
            CourseVideoViewSubject(videoTitle: video.title, videoUrl: "")
        }
    }
}

struct TopicVideo: Identifiable {
    let id: Int
    let title: String
    let duration: String
    let thumbnailUrl: String
}

struct CourseVideoViewSubject: View {
    let videoTitle: String
    let videoUrl: String
    
    var body: some View {
        VStack {
            Text("Playing \(videoTitle)")
                .font(.title)
                .padding()
            
            // Placeholder for video player
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
                .frame(height: 300)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                )
        }
        .navigationTitle("Video Player")
    }
}

struct Topic: Identifiable {
    let id: Int
    let name: String
    let subject: String
    let description: String
    let videoUrl: String
}

struct SubjectList: Identifiable {
    let id: Int
    let name: String
    let color: Color
}

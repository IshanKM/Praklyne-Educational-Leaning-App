import SwiftUI

struct Topic: Identifiable {
    let id: Int
    let name: String
    let subject: String
    let description: String
    let videos: [TopicVideo] // multiple videos per topic
}

struct TopicVideo: Identifiable {
    let id: Int
    let title: String
    let duration: String
    let videoUrl: String
}

struct LearningSubject {
    let id: Int
    let name: String
    let color: Color
}

let allTopics: [Topic] = [
    // Science Topics
    Topic(
        id: 1,
        name: "Electricity",
        subject: "Science",
        description: """
Electricity is the flow of electric charge through a conductor. It is the foundation of modern technology, powering homes, industries, and devices. Key concepts include current, voltage, resistance, Ohm's law, circuits (series and parallel), and safety precautions. Understanding electricity is essential for physics, engineering, and daily life.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Electricity", duration: "10:30", videoUrl: "https://www.youtube.com/watch?v=mc979OhitAg"),
            TopicVideo(id: 2, title: "Ohm's Law Explained", duration: "12:45", videoUrl: "https://www.youtube.com/watch?v=example2"),
            TopicVideo(id: 3, title: "Series & Parallel Circuits", duration: "15:20", videoUrl: "https://www.youtube.com/watch?v=example3")
        ]
    ),
    Topic(
        id: 2,
        name: "Gravitation",
        subject: "Science",
        description: """
Gravitation is the force of attraction between all objects with mass. It governs planetary motion, causes objects to fall to the ground, and explains tidal phenomena. Topics include Newton’s law of universal gravitation, gravitational acceleration, weight, and mass, as well as real-world applications in astronomy and space exploration.
""",
        videos: [
            TopicVideo(id: 1, title: "Gravitational Force Basics", duration: "11:20", videoUrl: "https://www.youtube.com/watch?v=7gf6YpdvtE0"),
            TopicVideo(id: 2, title: "Newton's Law of Gravitation", duration: "14:10", videoUrl: "https://www.youtube.com/watch?v=example4")
        ]
    ),
    Topic(
        id: 3,
        name: "Oscillation",
        subject: "Science",
        description: """
Oscillation refers to repetitive motion around an equilibrium point. Examples include pendulums, springs, sound waves, and alternating currents. Topics cover amplitude, frequency, period, damping, resonance, and their applications in physics, engineering, and natural phenomena.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Oscillation", duration: "9:50", videoUrl: "https://www.youtube.com/watch?v=qJLFjWqxTmw"),
            TopicVideo(id: 2, title: "Pendulums and Springs", duration: "13:05", videoUrl: "https://www.youtube.com/watch?v=example5")
        ]
    ),
    Topic(
        id: 4,
        name: "Magnetic Fields",
        subject: "Science",
        description: """
Magnetism arises from moving electric charges and magnetic materials. This topic explores magnetic fields, their effects on materials, electromagnetism, and applications in motors, generators, and electronics. Understanding magnetic fields is critical in physics and engineering.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Magnetism", duration: "10:45", videoUrl: "https://www.youtube.com/watch?v=hFAOXdXZ5TM"),
            TopicVideo(id: 2, title: "Electromagnetic Fields", duration: "12:50", videoUrl: "https://www.youtube.com/watch?v=example6")
        ]
    ),
    Topic(
        id: 5,
        name: "Thermodynamics",
        subject: "Science",
        description: """
Thermodynamics studies heat, work, energy transfer, and temperature. Topics include the laws of thermodynamics, heat engines, entropy, and real-world applications in engines, refrigerators, and climate science. It forms the basis of physics and engineering.
""",
        videos: [
            TopicVideo(id: 1, title: "Laws of Thermodynamics", duration: "11:35", videoUrl: "https://www.youtube.com/watch?v=NyOYW07-L5g"),
            TopicVideo(id: 2, title: "Heat and Energy Transfer", duration: "14:15", videoUrl: "https://www.youtube.com/watch?v=example7")
        ]
    ),

    // Maths Topics
    Topic(
        id: 6,
        name: "Algebra",
        subject: "Maths",
        description: """
Algebra deals with symbols and rules for manipulating them. Topics include variables, equations, functions, polynomials, and inequalities. Algebra is the foundation for higher mathematics, problem solving, and applications in science and engineering.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Algebra", duration: "9:50", videoUrl: "https://www.youtube.com/watch?v=NybHckSEQBI"),
            TopicVideo(id: 2, title: "Equations & Expressions", duration: "11:30", videoUrl: "https://www.youtube.com/watch?v=example8")
        ]
    ),
    Topic(
        id: 7,
        name: "Geometry",
        subject: "Maths",
        description: """
Geometry studies shapes, sizes, positions, and spatial relationships. Topics include points, lines, angles, triangles, circles, and polygons. Geometry is essential for mathematics, architecture, engineering, and real-world problem solving.
""",
        videos: [
            TopicVideo(id: 1, title: "Basic Geometry Concepts", duration: "10:25", videoUrl: "https://www.youtube.com/watch?v=g1ib43q3uXQ")
        ]
    ),
    Topic(
        id: 8,
        name: "Calculus",
        subject: "Maths",
        description: """
Calculus studies change and motion through derivatives and integrals. Topics include limits, differentiation, integration, and applications in physics, engineering, and economics.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Calculus", duration: "12:10", videoUrl: "https://www.youtube.com/watch?v=WUvTyaaNkzM")
        ]
    ),
    Topic(
        id: 9,
        name: "Statistics",
        subject: "Maths",
        description: """
Statistics is the study of data collection, analysis, interpretation, and presentation. Topics include probability, mean, median, variance, standard deviation, and hypothesis testing. Statistics is widely used in science, business, and social studies.
""",
        videos: [
            TopicVideo(id: 1, title: "Basics of Statistics", duration: "10:00", videoUrl: "https://www.youtube.com/watch?v=uhxtUt_-GyM")
        ]
    ),

    // Programming Topics
    Topic(
        id: 10,
        name: "Swift Basics",
        subject: "Programming",
        description: """
Swift is a modern programming language for Apple platforms. This topic introduces variables, constants, data types, operators, control flow, functions, and basic object-oriented concepts. Learning Swift basics is essential for app development.
""",
        videos: [
            TopicVideo(id: 1, title: "Variables & Constants", duration: "8:30", videoUrl: "https://www.youtube.com/watch?v=Ulp1Kimblg0"),
            TopicVideo(id: 2, title: "Control Flow in Swift", duration: "12:00", videoUrl: "https://www.youtube.com/watch?v=example3")
        ]
    ),
    Topic(
        id: 11,
        name: "Data Structures",
        subject: "Programming",
        description: """
Data structures organize data for efficient access and modification. Topics include arrays, linked lists, stacks, queues, trees, and graphs. Understanding data structures is essential for algorithm design and programming.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Data Structures", duration: "11:45", videoUrl: "https://www.youtube.com/watch?v=RBSGKlAvoiM")
        ]
    ),
    Topic(
        id: 12,
        name: "Object-Oriented Programming",
        subject: "Programming",
        description: """
OOP is a programming paradigm using objects and classes. Topics include inheritance, polymorphism, encapsulation, and abstraction. OOP improves code modularity, reusability, and maintainability.
""",
        videos: [
            TopicVideo(id: 1, title: "OOP Concepts", duration: "13:20", videoUrl: "https://www.youtube.com/watch?v=pTB0EiLXUC8")
        ]
    ),

    // History Topics
    Topic(
        id: 16,
        name: "World War II",
        subject: "History",
        description: """
World War II was a global conflict from 1939 to 1945 involving major world powers. Topics include causes of the war, major battles, political leaders, the Holocaust, technological advancements, and the war's impact on global politics and society.
""",
        videos: [
            TopicVideo(id: 1, title: "WWII Overview", duration: "15:00", videoUrl: "https://www.youtube.com/watch?v=_uk_6vfqwTA")
        ]
    ),
    Topic(
        id: 17,
        name: "Ancient Civilizations",
        subject: "History",
        description: """
Study of early civilizations such as Egypt, Greece, and Rome. Topics include culture, governance, economy, architecture, and achievements. Understanding ancient civilizations helps explain the roots of modern society.
""",
        videos: [
            TopicVideo(id: 1, title: "Egyptian Civilization", duration: "12:30", videoUrl: "https://www.youtube.com/watch?v=Z3Wvw6BuQvE")
        ]
    ),
    Topic(
        id: 18,
        name: "Industrial Revolution",
        subject: "History",
        description: """
The Industrial Revolution brought technological and social changes in the 18th and 19th centuries. Topics include inventions, factories, urbanization, and economic transformation. It is key to understanding modern industry and society.
""",
        videos: [
            TopicVideo(id: 1, title: "Introduction to Industrial Revolution", duration: "14:10", videoUrl: "https://www.youtube.com/watch?v=zhL5DCizj5c")
        ]
    ),

    // Geography Topics
    Topic(
        id: 19,
        name: "Rivers of the World",
        subject: "Geography",
        description: """
Rivers are natural watercourses important for ecology, transport, agriculture, and human settlements. Topics include major rivers, river systems, hydrology, and the environmental impact of human activity.
""",
        videos: [
            TopicVideo(id: 1, title: "Major Rivers Overview", duration: "11:00", videoUrl: "https://www.youtube.com/watch?v=YwVAGVcncdk")
        ]
    ),
    Topic(
        id: 20,
        name: "Mountains and Plateaus",
        subject: "Geography",
        description: """
Mountains and plateaus shape Earth's surface and influence climate, biodiversity, and human activity. Topics include mountain formation, major ranges, types of plateaus, and geological processes.
""",
        videos: [
            TopicVideo(id: 1, title: "Mountain Formation", duration: "10:50", videoUrl: "https://www.youtube.com/watch?v=example9")
        ]
    )
]

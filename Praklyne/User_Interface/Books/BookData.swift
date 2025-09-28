import SwiftUI

struct Book: Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    let author: String
    let category: String
    let rating: Double
    let pages: Int
    let coverImage: String
    let pdfFileName: String
    var readingProgress: Double
    var isFavorite: Bool
    let description: String
}


extension Book {
    static let sampleBooks: [Book] = [
        Book(id: UUID(), title: "A Day of Fallen Night",
             author: "Samantha Shannon",
             category: "Fantasy",
             rating: 4.2,
             pages: 250,
             coverImage: "book_fallen_night",
             pdfFileName: "example_book",
             readingProgress: 0.0,
             isFavorite: false,
             description: "An epic standalone prequel with dragons, ancient magic, and warring kingdoms."),

        Book(id: UUID(), title: "The Best Novel",
             author: "Robert McCrum",
             category: "Fantasy",
             rating: 4.0,
             pages: 300,
             coverImage: "thebestnovel",
             pdfFileName: "example_book",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A celebrated fantasy tale praised for its worldbuilding and character depth."),

        Book(id: UUID(), title: "Classic Tale",
             author: "Jane Doe",
             category: "Classics",
             rating: 4.8,
             pages: 250,
             coverImage: "ClassicTale",
             pdfFileName: "classic.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A timeless classic that shaped modern literature and storytelling."),

        Book(id: UUID(), title: "Sci-Fi Adventure",
             author: "Alex Mercer",
             category: "Sci-Fi",
             rating: 4.5,
             pages: 320,
             coverImage: "Sci-FiAdventure",
             pdfFileName: "scifi_adventure.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A thrilling journey across space and time with epic battles and alien worlds."),

        Book(id: UUID(), title: "The WOLFDEN",
             author: "Erin Knight",
             category: "Fantasy",
             rating: 4.3,
             pages: 280,
             coverImage: "TheWOLFDEN",
             pdfFileName: "the_wolfden.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "Mystery and magic collide in a dark forest ruled by mythical creatures."),

        Book(id: UUID(), title: "Brain Intro",
             author: "Dr. Linda Shaw",
             category: "Science",
             rating: 4.7,
             pages: 200,
             coverImage: "brainintro",
             pdfFileName: "brain_intro.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A beginner-friendly introduction to neuroscience and how the brain works."),

        Book(id: UUID(), title: "The Lost Kingdom",
             author: "Samuel Green",
             category: "Fantasy",
             rating: 4.1,
             pages: 310,
             coverImage: "lostkingdom",
             pdfFileName: "lost_kingdom.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A tale of forgotten realms, heroic quests, and powerful artifacts."),

        Book(id: UUID(), title: "Galactic Horizons",
             author: "Tina Howard",
             category: "Sci-Fi",
             rating: 4.6,
             pages: 340,
             coverImage: "galactichorizons",
             pdfFileName: "galactic_horizons.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "Explore distant galaxies and encounter civilizations beyond imagination."),

        Book(id: UUID(), title: "Ancient Philosophy",
             author: "Marcus Aurelius",
             category: "Classics",
             rating: 4.9,
             pages: 220,
             coverImage: "ancientphilosophy",
             pdfFileName: "ancient_philosophy.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "Wisdom from the great thinkers of ancient times, guiding modern life.")
    ]
}


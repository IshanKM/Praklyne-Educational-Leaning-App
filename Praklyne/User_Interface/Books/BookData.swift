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
             coverImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRCNBG25Www6vDkm7fxYvJkFpMaIBu9Su_pQ&s",
             pdfFileName: "example_book",
             readingProgress: 0.0,
             isFavorite: false,
             description: "An epic standalone prequel with dragons, ancient magic, and warring kingdoms."),

        Book(id: UUID(), title: "The Best Novel",
             author: "Robert McCrum",
             category: "Fantasy",
             rating: 4.0,
             pages: 300,
             coverImage: "https://m.media-amazon.com/images/I/51EYGYVgyIL.jpg",
             pdfFileName: "example_book",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A celebrated fantasy tale praised for its worldbuilding and character depth."),

        Book(id: UUID(), title: "Classic Tale",
             author: "Jane Doe",
             category: "Classics",
             rating: 4.8,
             pages: 250,
             coverImage: "https://i.ebayimg.com/images/g/nJwAAOSwGVRjCepi/s-l400.jpg",
             pdfFileName: "classic.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A timeless classic that shaped modern literature and storytelling."),

        Book(id: UUID(), title: "Sci-Fi Adventure",
             author: "Alex Mercer",
             category: "Sci-Fi",
             rating: 4.5,
             pages: 320,
             coverImage: "Sci-https://m.media-amazon.com/images/I/81RLUVIEAyL._UF1000,1000_QL80_.jpg",
             pdfFileName: "scifi_adventure.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A thrilling journey across space and time with epic battles and alien worlds."),

        Book(id: UUID(), title: "The WOLFDEN",
             author: "Erin Knight",
             category: "Fantasy",
             rating: 4.3,
             pages: 280,
             coverImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQozUjh2sHOrW1rTkwe-a18v48L6tHZWizHWg&s",
             pdfFileName: "the_wolfden.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "Mystery and magic collide in a dark forest ruled by mythical creatures."),

        Book(id: UUID(), title: "Brain Intro",
             author: "Dr. Linda Shaw",
             category: "Science",
             rating: 4.7,
             pages: 200,
             coverImage: "https://m.media-amazon.com/images/I/41gS+ruNKmL._AC_UF1000,1000_QL80_.jpg",
             pdfFileName: "brain_intro.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A beginner-friendly introduction to neuroscience and how the brain works."),

        Book(id: UUID(), title: "The Lost Kingdom",
             author: "Samuel Green",
             category: "Fantasy",
             rating: 4.1,
             pages: 310,
             coverImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTkMgjFWOliniKkISRfQ2y_wcIX9C5LyIJzA&s",
             pdfFileName: "lost_kingdom.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "A tale of forgotten realms, heroic quests, and powerful artifacts."),

        Book(id: UUID(), title: "Galactic Horizons",
             author: "Tina Howard",
             category: "Sci-Fi",
             rating: 4.6,
             pages: 340,
             coverImage: "https://i.thriftbooks.com/api/imagehandler/DE024B187FCA2DF707A35F11C3A29D6AAE1626AA.jpeg",
             pdfFileName: "galactic_horizons.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "Explore distant galaxies and encounter civilizations beyond imagination."),

        Book(id: UUID(), title: "Ancient Philosophy",
             author: "Marcus Aurelius",
             category: "Classics",
             rating: 4.9,
             pages: 220,
             coverImage: "https://m.media-amazon.com/images/I/81-Xe2PTvIL._AC_UF1000,1000_QL80_.jpg",
             pdfFileName: "ancient_philosophy.pdf",
             readingProgress: 0.0,
             isFavorite: false,
             description: "Wisdom from the great thinkers of ancient times, guiding modern life.")
    ]
}


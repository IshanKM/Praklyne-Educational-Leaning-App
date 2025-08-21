import SwiftUI

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let category: String
    let rating: Double
    let pages: Int
    let coverImage: String
    let pdfFileName: String
    var readingProgress: Double = 0.0
    let description: String
}


extension Book {
    static let sampleBooks: [Book] = [
        Book(title: "A Day of Fallen Night",
             author: "Samantha Shannon",
             category: "Fantasy",
             rating: 4.2,
             pages:250,
             coverImage: "book_fallen_night",
             pdfFileName: "fallen_night.pdf",
             readingProgress: 0.3,
             description: "An epic standalone prequel with dragons, ancient magic, and warring kingdoms."),
        Book(title: "The Best Novel",
             author: "Robert McCrum",
             category: "Fantasy",
             rating: 4.0,
             pages:300,
             coverImage: "book_best_novel",
             pdfFileName: "best_novel.pdf",
             description: "A celebrated fantasy tale praised for its worldbuilding and character depth."),
        Book(title: "The 100 Best Novels",
             author: "Robert McCrum",
             category: "Fantasy",
             rating: 4.0,
             pages:150,
             coverImage: "book_100_best",
             pdfFileName: "100_best.pdf",
             description: "A curated anthology highlighting influential novels across eras."),
        Book(title: "The WOLF DEN",
             author: "ELODIE HARPER",
             category: "Fantasy",
             rating: 4.0,
             pages:450,
             coverImage: "book_wolf_den",
             pdfFileName: "wolf_den.pdf",
             description: "A gripping historical tale of survival and power in ancient Pompeii."),
        Book(title: "Sci-Fi Adventure",
             author: "John Smith",
             category: "Sci-Fi",
             rating: 4.5,
             pages:400,
             coverImage: "book_scifi",
             pdfFileName: "scifi.pdf",
             description: "A high-octane journey through space with bold ideas and heart."),
        Book(title: "Classic Tale",
             author: "Jane Doe",
             category: "Classics",
             rating: 4.8,
             pages:250,
             coverImage: "book_classic",
             pdfFileName: "classic.pdf",
             description: "A timeless classic that shaped modern literature and storytelling.")
    ]
}


struct BooksView: View {
    @State private var selectedCategory = "All"
    @State private var showContinueReading = true
    
    let categories = ["All", "Sci-Fi", "Fantasy", "Classics", "Dark Academia"]
    let books = Book.sampleBooks
    
    var filteredBooks: [Book] {
        if selectedCategory == "All" {
            return books
        }
        return books.filter { $0.category == selectedCategory }
    }
    
    var continueReadingBooks: [Book] {
        return books.filter { $0.readingProgress > 0 }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
               
                Color(red: 0.2, green: 0.6, blue: 0.5)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                       
                        VStack(spacing: 20) {
                            headerView
                            
                            if showContinueReading && !continueReadingBooks.isEmpty {
                                continueReadingSection
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                        
                       
                        VStack(spacing: 20) {
                            categoryTabsView
                            bookListSection
                            Spacer(minLength: 200)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height)
                        .background(Color.white)
                    }
                }

            }
        }
        .navigationBarHidden(true)
    }
    
 
    private var headerView: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("English Books")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "heart")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
    }
    
  
    private var continueReadingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Continue Reading")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: { showContinueReading = false }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(continueReadingBooks) { book in
                        ContinueReadingCard(book: book)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
   
    private var categoryTabsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryTab(
                        title: category,
                        isSelected: selectedCategory == category
                    ) { selectedCategory = category }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
   
    private var bookListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("\(selectedCategory) Book List")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(filteredBooks) { book in
                    BookCard(book: book)
                }
            }
        }
    }
}


struct ContinueReadingCard: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 80)
                .overlay(Text("📖").font(.title))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(book.author)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: book.readingProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .frame(height: 4)
                    
                    Text("\(Int(book.readingProgress * 100))%")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Button("Read Book") {}
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .frame(width: 280)
    }
}


struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}


struct BookCard: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .overlay(Text("📚").font(.system(size: 40)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Text(book.author)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", book.rating))
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title3)
                    }
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}


struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView()
    }
}

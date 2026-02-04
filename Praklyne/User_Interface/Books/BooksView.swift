import SwiftUI



struct BooksView: View {
    @State private var selectedCategory = "All"
    @State private var showContinueReading = true
    @State private var books: [Book] = []
    @State private var showFavorites = false

    @Environment(\.dismiss) var dismiss
    
    let categories = ["All", "Sci-Fi", "Fantasy", "Classics", "Dark Academia"]
    
    var filteredBooks: [Book] {
        selectedCategory == "All" ? books : books.filter { $0.category == selectedCategory }
    }
    
    var continueReadingBooks: [Book] {
        books.filter { $0.readingProgress > 0 }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 0.2, green: 0.6, blue: 0.5).ignoresSafeArea()
            
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
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .background(Color.white)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear { loadBooks() }
    }

    
   
    
    private var headerView: some View {
        HStack {
           
            Button(action: {
                dismiss()
            }) {
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
            
            Button(action: {
                showFavorites = true
            }) {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .fullScreenCover(isPresented: $showFavorites) {
                FavoriteBooksView(
                    books: books.filter { $0.isFavorite },
                    onUpdate: updateBook
                )
            }

        }
        .padding(.top, 10)
    }
    
    private var continueReadingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Continue Reading").font(.headline).foregroundColor(.white)
                Spacer()
                Button(action: { showContinueReading = false }) { Image(systemName: "xmark").foregroundColor(.white) }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(continueReadingBooks) { book in
                        ContinueReadingCard(book: book, onUpdate: updateBook)
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
                    CategoryTab(title: category, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var bookListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(selectedCategory) Book List").font(.headline).foregroundColor(.black)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(filteredBooks) { book in
                    BookCard(book: book, onUpdate: updateBook)
                }
            }
        }
    }
    
 
    
    private func updateBook(_ updated: Book) {
        if let index = books.firstIndex(where: { $0.id == updated.id }) {
            books[index] = updated
            saveBooks()
        }
    }
    
    private func loadBooks() {
        if let data = UserDefaults.standard.data(forKey: "books"),
           let savedBooks = try? JSONDecoder().decode([Book].self, from: data) {
            books = savedBooks
        } else {
            books = Book.sampleBooks
            saveBooks()
        }
    }
    
    private func saveBooks() {
        if let data = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(data, forKey: "books")
        }
    }
    
    private func goBack() {
       
    }
}



struct ContinueReadingCard: View {
    var book: Book
    var onUpdate: (Book) -> Void
    @State private var showPDF = false
    @State private var progress: Double = 0.0
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: book.coverImage)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 100, height: 140)
                        .cornerRadius(8)
                        .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(book.title).font(.headline).fontWeight(.semibold).foregroundColor(.black).lineLimit(2)
                Text(book.author).font(.subheadline).foregroundColor(.gray)
                
                ProgressView(value: book.readingProgress).progressViewStyle(LinearProgressViewStyle(tint: .orange)).frame(height: 6).clipShape(Capsule())
                Text("\(Int(book.readingProgress * 100))% completed").font(.caption).foregroundColor(.gray)
                
                Button(action: { progress = book.readingProgress; showPDF = true }) {
                    Text("Continue Reading").font(.caption).padding(.horizontal, 16).padding(.vertical, 8).background(Color.orange).foregroundColor(.white).cornerRadius(20)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12).background(Color.white).cornerRadius(16).shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 3).frame(width: 320)
        .fullScreenCover(isPresented: $showPDF) {
            PDFReaderView(book: book, progress: $progress).onDisappear {
                var updated = book
                updated.readingProgress = progress
                onUpdate(updated)
            }
        }
    }
}

struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title).font(.subheadline).padding(.horizontal, 16).padding(.vertical, 8).background(isSelected ? Color.orange : Color.gray.opacity(0.2)).foregroundColor(isSelected ? .white : .black).cornerRadius(20)
        }
    }
}

struct BookCard: View {
    var book: Book
    var onUpdate: (Book) -> Void
    @State private var showDetail = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: book.coverImage)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 140, height: 200)
                        .cornerRadius(8)
                        .clipped()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(book.title).font(.headline).fontWeight(.semibold).foregroundColor(.black).lineLimit(2)
                Text(book.author).font(.subheadline).foregroundColor(.gray)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption)
                        Text(String(format: "%.1f", book.rating)).font(.caption).foregroundColor(.black)
                    }
                    Spacer()
                    Button(action: { showDetail = true }) {
                        Image(systemName: "arrow.right.circle.fill").foregroundColor(.orange).font(.title3)
                    }.fullScreenCover(isPresented: $showDetail) {
                        BookDetailView(book: book, onUpdate: onUpdate)
                    }
                }
            }.padding(.horizontal, 4)
        }
        .padding().background(Color.white).cornerRadius(16).shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        BooksView()
    }
}

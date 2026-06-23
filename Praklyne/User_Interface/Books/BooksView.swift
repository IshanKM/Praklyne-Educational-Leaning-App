import SwiftUI

// MARK: - BOOKS VIEW
struct BooksView: View {
    @State private var selectedCategory = "All"
    @State private var showContinueReading = true
    @State private var books: [Book] = []
    @State private var showFavorites = false

    @StateObject private var bookService = BookService()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let categories = ["All", "Sci-Fi", "Fantasy", "Classics", "Dark Academia"]

    var filteredBooks: [Book] {
        selectedCategory == "All" ? books : books.filter { $0.category == selectedCategory }
    }

    var continueReadingBooks: [Book] {
        books.filter { $0.readingProgress > 0 }
    }

    var body: some View {
        ZStack {
            // ── Dynamic Background ──
            ambientBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ── Header Bar ──
                headerView
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        
                        // ── Continue Reading Section ──
                        if showContinueReading && !continueReadingBooks.isEmpty {
                            continueReadingSection
                                .padding(.horizontal, 20)
                                .transition(.opacity.combined(with: .scale))
                        }
                        
                        // ── Main Book Catalog ──
                        VStack(spacing: 20) {
                            categoryTabsView
                            
                            bookListSection
                                .padding(.horizontal, 20)
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 36)
                        .frame(maxWidth: .infinity)
                        .background(
                            colorScheme == .dark ? Color(hex: "#0F172A") : Color.white
                        )
                        .cornerRadius(32, corners: [.topLeft, .topRight])
                        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.05), radius: 15, x: 0, y: -8)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            bookService.fetchBooks()
        }
        .onReceive(bookService.$books) { fetchedBooks in
            self.books = fetchedBooks
        }
    }

    // MARK: - Subviews
    
    private var ambientBackground: some View {
        let colors: [Color]
        if colorScheme == .dark {
            colors = [Color(hex: "#064E3B").opacity(0.85), Color(hex: "#0B132B")]
        } else {
            colors = [Color(hex: "#059669"), Color(hex: "#10B981")]
        }
        return LinearGradient(
            colors: colors,
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 40, height: 40)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }

            Spacer()

            Text("English Books")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Spacer()

            Button(action: { showFavorites = true }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 40, height: 40)
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
            }
            .fullScreenCover(isPresented: $showFavorites) {
                FavoriteBooksView(
                    books: books.filter { $0.isFavorite },
                    onUpdate: updateBook
                )
            }
        }
    }

    // MARK: - Continue Reading
    private var continueReadingSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Continue Reading")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    withAnimation {
                        showContinueReading = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(continueReadingBooks) { book in
                        ContinueReadingCard(book: book, onUpdate: updateBook)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - Categories
    private var categoryTabsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    CategoryTab(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Book List
    private var bookListSection: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("\(selectedCategory) Books")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)],
                spacing: 20
            ) {
                ForEach(filteredBooks) { book in
                    BookCard(book: book, onUpdate: updateBook)
                }
            }
        }
    }

    // MARK: - Update Book
    private func updateBook(_ updated: Book) {
        if let index = books.firstIndex(where: { $0.id == updated.id }) {
            books[index] = updated
            bookService.updateBook(updated)
        }
    }
}

// MARK: - CONTINUE READING CARD
struct ContinueReadingCard: View {
    var book: Book
    var onUpdate: (Book) -> Void
    @State private var showPDF = false
    @State private var progress: Double = 0.0
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(spacing: 14) {
            // Floating Cover Artwork
            AsyncImage(url: URL(string: book.coverImage)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.15))
            }
            .frame(width: 86, height: 120)
            .cornerRadius(12)
            .clipped()
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.35 : 0.15), radius: 8, x: 0, y: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(book.author)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: book.readingProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#F59E0B")))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Text("\(Int(book.readingProgress * 100))% completed")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    progress = book.readingProgress
                    showPDF = true
                }) {
                    Text("Continue")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(14)
                        .shadow(color: Color(hex: "#F59E0B").opacity(0.3), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(BookPressableButtonStyle())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(
            ZStack {
                if colorScheme == .dark {
                    Color(hex: "#1E293B").opacity(0.85)
                } else {
                    Color.white.opacity(0.85)
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.6), lineWidth: 1)
            )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.25 : 0.06), radius: 10, y: 4)
        .frame(width: 290)
        .fullScreenCover(isPresented: $showPDF) {
            PDFReaderView(book: book, progress: $progress)
                .onDisappear {
                    var updated = book
                    updated.readingProgress = progress
                    onUpdate(updated)
                }
        }
    }
}

// MARK: - CATEGORY TAB
struct CategoryTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            LinearGradient(
                                colors: colorScheme == .dark ? 
                                    [Color.white.opacity(0.08), Color.white.opacity(0.08)] : 
                                    [Color.black.opacity(0.04), Color.black.opacity(0.04)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        }
                    }
                )
                .foregroundColor(isSelected ? .white : .secondary)
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            Color.white.opacity(isSelected ? 0.2 : (colorScheme == .dark ? 0.05 : 0.1)),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - BOOK CARD
struct BookCard: View {
    var book: Book
    var onUpdate: (Book) -> Void
    @State private var showDetail = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Book cover image with 3D shadow depth
            AsyncImage(url: URL(string: book.coverImage)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
            }
            .frame(height: 190)
            .frame(maxWidth: .infinity)
            .cornerRadius(12)
            .clipped()
            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.15), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.08 : 0.4), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .frame(height: 40, alignment: .topLeading)

                Text(book.author)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 4)

            HStack {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#F59E0B"))
                    Text(String(format: "%.1f", book.rating))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { showDetail = true }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(Color(hex: "#10B981"))
                        .font(.title3)
                }
                .buttonStyle(BookPressableButtonStyle())
                .fullScreenCover(isPresented: $showDetail) {
                    BookDetailView(book: book, onUpdate: onUpdate)
                }
            }
            .padding(.horizontal, 4)
            .padding(.top, 4)
        }
        .padding(12)
        .background(
            colorScheme == .dark ? Color(hex: "#1E293B").opacity(0.5) : Color.white
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    colorScheme == .dark ? Color.white.opacity(0.06) : Color.black.opacity(0.03),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, y: 4)
    }
}

// MARK: - Pressed Style Helper
struct BookPressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

// MARK: - Corners Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

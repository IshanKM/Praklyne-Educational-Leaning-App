import SwiftUI

struct BookDetailView: View {
    @State var book: Book
    var onUpdate: (Book) -> Void

    @State private var isFavorite: Bool = false
    @State private var showPDFReader = false
    @State private var readingProgress: Double = 0.0

    // 🔥 Use existing service (DO NOT redefine it)
    private let bookService = BookService()

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }

                    Spacer()

                    VStack(spacing: 4) {
                        Text(book.title)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .lineLimit(1)

                        Text(book.author)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Button(action: {
                        isFavorite.toggle()
                        book.isFavorite = isFavorite

                        onUpdate(book)                 // update UI
                        bookService.updateBook(book)   // 🔥 update Firebase
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // MARK: - Cover
                AsyncImage(url: URL(string: book.coverImage)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 180, height: 270)
                .cornerRadius(8)
                .clipped()

                // MARK: - Info
                HStack(spacing: 20) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", book.rating))
                            .foregroundColor(.black)
                    }

                    Text(book.category)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange)
                        .cornerRadius(15)

                    Text("\(book.pages) pages")
                        .foregroundColor(.black)

                    if book.readingProgress > 0 {
                        Text("\(Int(book.readingProgress * 100))% Read")
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 25)

                // MARK: - Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Summary")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)

                    Text(book.description)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)

                // MARK: - Actions
                HStack(spacing: 16) {
                    Button(action: {}) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 50)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(12)
                    }

                    Button(action: {
                        readingProgress = book.readingProgress
                        showPDFReader = true
                    }) {
                        Text("Read This Book")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .fullScreenCover(isPresented: $showPDFReader) {
                        PDFReaderView(book: book, progress: $readingProgress)
                            .onDisappear {
                                book.readingProgress = readingProgress

                                onUpdate(book)               // update UI
                                bookService.updateBook(book) // 🔥 save to Firebase
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 100)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            isFavorite = book.isFavorite
        }
    }
}


struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book.sampleBooks[0], onUpdate: { _ in })
    }
}

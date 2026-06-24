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
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            // ── Background color ──
            if #available(iOS 17.0, *) {
                Color(colorScheme == .dark ? Color(hex: "#0F172A") : Color(hex: "#F8FAFC"))
                    .ignoresSafeArea()
            } else {
                // Fallback on earlier versions
            }
            
            // ── Dynamic Ambient Blur Backdrop (Cover Image Glow) ──
            GeometryReader { geo in
                AsyncImage(url: URL(string: book.coverImage)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.clear
                }
                .frame(width: geo.size.width, height: geo.size.height * 0.5)
                .blur(radius: 50)
                .opacity(colorScheme == .dark ? 0.25 : 0.15)
                .ignoresSafeArea()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    
                    // ── Header Bar ──
                    headerBarView
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    
                    // ── Book Cover Display ──
                    AsyncImage(url: URL(string: book.coverImage)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.secondary.opacity(0.1))
                    }
                    .frame(width: 170, height: 250)
                    .cornerRadius(16)
                    .clipped()
                    .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.45 : 0.2), radius: 16, x: 0, y: 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.5), lineWidth: 1.5)
                    )
                    
                    // ── Metrics Row (Frosted Glass Container) ──
                    metricsRowView
                        .padding(.horizontal, 20)
                    
                    // ── Summary & Info Card ──
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Summary")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text(book.description)
                            .font(.system(size: 14.5))
                            .foregroundColor(.secondary)
                            .lineSpacing(6)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        ZStack {
                            if colorScheme == .dark {
                                Color(hex: "#1E293B").opacity(0.4)
                            } else {
                                Color.white.opacity(0.7)
                            }
                        }
                        .background(.thinMaterial)
                        .cornerRadius(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white.opacity(colorScheme == .dark ? 0.05 : 0.5), lineWidth: 1)
                        )
                    )
                    .padding(.horizontal, 20)
                    
                    // ── Primary Action Buttons ──
                    actionsView
                        .padding(.horizontal, 20)
                        .padding(.bottom, 48)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isFavorite = book.isFavorite
        }
    }
    
    // MARK: - Subviews
    
    private var headerBarView: some View {
        HStack {
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.4), lineWidth: 1)
                        )
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(spacing: 3) {
                Text(book.title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(book.author)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: 220)

            Spacer()

            Button(action: {
                isFavorite.toggle()
                book.isFavorite = isFavorite

                onUpdate(book)                 // update UI
                bookService.updateBook(book)   // 🔥 update Firebase
            }) {
                ZStack {
                    Circle()
                        .fill(isFavorite ? Color.red.opacity(0.12) : Color.primary.opacity(0.06))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(isFavorite ? Color.red.opacity(0.2) : Color.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(isFavorite ? .red : .primary)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private var metricsRowView: some View {
        HStack(spacing: 16) {
            
            // Rating
            VStack(spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(hex: "#F59E0B"))
                    Text(String(format: "%.1f", book.rating))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                }
                Text("Rating")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 32)
            
            // Category
            VStack(spacing: 6) {
                Text(book.category)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#F59E0B"), Color(hex: "#D97706")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                Text("Category")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 32)
            
            // Pages / Progress
            VStack(spacing: 6) {
                if book.readingProgress > 0 {
                    Text("\(Int(book.readingProgress * 100))% Read")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                } else {
                    Text("\(book.pages) pgs")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Text(book.readingProgress > 0 ? "Progress" : "Pages")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
        .background(
            ZStack {
                if colorScheme == .dark {
                    Color(hex: "#1E293B").opacity(0.4)
                } else {
                    Color.white.opacity(0.7)
                }
            }
            .background(.thinMaterial)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(colorScheme == .dark ? 0.05 : 0.5), lineWidth: 1)
            )
        )
        .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.2 : 0.04), radius: 8, y: 4)
    }
    
    private var actionsView: some View {
        HStack(spacing: 16) {
            
            // Share or Utility Button
            Button(action: {}) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(hex: "#F59E0B").opacity(0.12))
                        .frame(width: 54, height: 54)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(hex: "#F59E0B").opacity(0.2), lineWidth: 1)
                        )
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(hex: "#F59E0B"))
                }
            }
            .buttonStyle(BookDetailPressableButtonStyle())

            // Primary Read Button
            Button(action: {
                readingProgress = book.readingProgress
                showPDFReader = true
            }) {
                Text(book.readingProgress > 0 ? "Continue Reading" : "Read This Book")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#10B981"), Color(hex: "#059669")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: Color(hex: "#10B981").opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(BookDetailPressableButtonStyle())
            .fullScreenCover(isPresented: $showPDFReader) {
                PDFReaderView(book: book, progress: $readingProgress)
                    .onDisappear {
                        book.readingProgress = readingProgress

                        onUpdate(book)               // update UI
                        bookService.updateBook(book) // 🔥 save to Firebase
                    }
            }
        }
    }
}

// MARK: - Pressed Style Helper
struct BookDetailPressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .brightness(configuration.isPressed ? -0.04 : 0.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book.sampleBooks[0], onUpdate: { _ in })
    }
}

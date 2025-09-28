import SwiftUI

struct FavoriteBooksView: View {
    var books: [Book]
    var onUpdate: (Book) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Favorite Books")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    Spacer()
                    Spacer().frame(width: 24) 
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                if books.isEmpty {
                    Spacer()
                    Text("No favorite books yet.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(books) { book in
                                NavigationLink {
                                    BookDetailView(book: book, onUpdate: onUpdate)
                                } label: {
                                    HStack {
                                        Image(book.coverImage)
                                            .resizable()
                                            .frame(width: 60, height: 90)
                                            .cornerRadius(6)
                                        VStack(alignment: .leading) {
                                            Text(book.title)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text(book.author)
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        if book.isFavorite {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}

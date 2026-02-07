import FirebaseFirestore

class BookService: ObservableObject {
    @Published var books: [Book] = []
    private let db = Firestore.firestore()
    
    func fetchBooks() {
        db.collection("booklist").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
                return
            }
            
            self.books = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                return Book(
                    id: UUID(),
                    title: data["title"] as? String ?? "",
                    author: data["author"] as? String ?? "",
                    category: data["category"] as? String ?? "",
                    rating: data["rating"] as? Double ?? 0.0,
                    pages: data["pages"] as? Int ?? 0,
                    coverImage: data["coverImage"] as? String ?? "",
                    pdfFileName: data["pdfFileName"] as? String ?? "",
                    readingProgress: data["readingProgress"] as? Double ?? 0.0,
                    isFavorite: data["isFavorite"] as? Bool ?? false,
                    description: data["description"] as? String ?? ""
                )
            } ?? []
        }
    }
    
    func updateBook(_ book: Book) {
        // Find the document and update it
        db.collection("booklist").whereField("title", isEqualTo: book.title).getDocuments { snapshot, error in
            if let document = snapshot?.documents.first {
                document.reference.updateData([
                    "readingProgress": book.readingProgress,
                    "isFavorite": book.isFavorite
                ]) { error in
                    if let error = error {
                        print("Error updating book: \(error.localizedDescription)")
                    } else {
                        print("Book updated successfully")
                    }
                }
            }
        }
    }
}

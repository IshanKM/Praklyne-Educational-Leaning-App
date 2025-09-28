import SwiftUI
import PDFKit

struct PDFReaderView: View {
    let book: Book
    @Binding var progress: Double
    
    @Environment(\.dismiss) var dismiss
    @State private var pdfView = PDFView()
    @State private var totalPages: Int = 0
    @State private var currentPage: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
        
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left").font(.title2).foregroundColor(.blue)
                }
                Spacer()
                Text("\(currentPage)/\(totalPages)").font(.subheadline).foregroundColor(.black)
                Spacer()
                Color.clear.frame(width: 24)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
            
        
            PDFKitView(pdfView: $pdfView, book: book, progress: $progress, currentPage: $currentPage, totalPages: $totalPages)
                .edgesIgnoringSafeArea(.all)
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if let document = pdfView.document {
                totalPages = document.pageCount
                let savedPageIndex = Int(progress * Double(totalPages))
                if savedPageIndex < totalPages,
                   let page = document.page(at: savedPageIndex) {
                    pdfView.go(to: page)
                    currentPage = savedPageIndex + 1
                }
            }
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    @Binding var pdfView: PDFView
    let book: Book
    @Binding var progress: Double
    @Binding var currentPage: Int
    @Binding var totalPages: Int
    
    func makeUIView(context: Context) -> PDFView {
        let view = pdfView
        if let url = Bundle.main.url(forResource: book.pdfFileName, withExtension: "pdf"),
           let document = PDFDocument(url: url) {
            view.document = document
            view.autoScales = true
            totalPages = document.pageCount
            
            NotificationCenter.default.addObserver(context.coordinator,
                                                   selector: #selector(Coordinator.pageChanged),
                                                   name: Notification.Name.PDFViewPageChanged,
                                                   object: view)
        }
        return view
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: PDFKitView
        
        init(_ parent: PDFKitView) {
            self.parent = parent
        }
        
        @objc func pageChanged(notification: Notification) {
            guard let pdfView = notification.object as? PDFView,
                  let currentPage = pdfView.currentPage,
                  let document = pdfView.document else { return }
            
            let index = document.index(for: currentPage)
            parent.currentPage = index + 1
            parent.progress = Double(index + 1) / Double(document.pageCount)
        }
    }
}

struct PDFReaderView_Previews: PreviewProvider {
    @State static var progress: Double = 0.0
    
    static var previews: some View {
        PDFReaderView(
            book: Book.sampleBooks[0],
            progress: $progress
        )
    }
}

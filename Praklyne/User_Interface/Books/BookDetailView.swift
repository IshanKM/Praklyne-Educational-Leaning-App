import SwiftUI

struct BookDetailView: View {
    let book: Book
    @State private var isFavorite = false
    @State private var showReviews = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
        
                HStack {
                    Button(action: {
               
                    }) {
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
                
               
                Image(book.coverImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 180, height: 270)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.top, 30)
                
             
                HStack(spacing: 20) {
             
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 16))
                        Text(String(format: "%.1f", book.rating))
                            .font(.system(size: 16, weight: .medium))
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
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                    
                   
                    if book.readingProgress > 0 {
                        Text("\(Int(book.readingProgress * 100))% Read")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 25)
                
              
                VStack(alignment: .leading, spacing: 16) {
                    Text("Summary")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(book.description)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                
         
                HStack(spacing: 16) {
                    Button(action: {
                        showReviews = true
                    }) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 50)
                            .background(Color.yellow.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
               
                    }) {
                        Text("Read This Book")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 100)
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .sheet(isPresented: $showReviews) {
     
        }
    }
}


struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book.sampleBooks[0])
    }
}

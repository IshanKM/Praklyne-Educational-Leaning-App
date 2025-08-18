import SwiftUI
import Foundation

struct HeaderView: View {
    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image("main_logo")
                    .resizable()
                    .frame(width: 80, height: 60)
                
                Text("Hey Ishan..!")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .padding(.top, 10)
        
        HStack {
            Text("Learn Theory through Practical Knowledge")
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding(.top, 2)
    }
}



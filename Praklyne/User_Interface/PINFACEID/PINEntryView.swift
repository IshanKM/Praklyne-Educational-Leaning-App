import SwiftUI

struct PINEntryView: View {
    @ObservedObject var lockManager: LockManager
    @State private var enteredPIN = ""
    let pinLength = 4
    
    var body: some View {
        VStack(spacing: 32) {
            
            Text("Enter your PIN")
                .font(.title2)
                .bold()
            
  
            HStack(spacing: 20) {
                ForEach(0..<pinLength, id: \.self) { index in
                    Circle()
                        .stroke(Color.orange, lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(index < enteredPIN.count ? Color.orange : Color.clear)
                        )
                }
            }
            
     
            if let error = lockManager.faceIDError {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
         
            Button(action: { lockManager.autoCheckFaceID() }) {
                VStack {
                    Image(systemName: "faceid")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Face ID")
                }
                .padding()
            }
            
     
            VStack(spacing: 16) {
                ForEach([["1","2","3"],["4","5","6"],["7","8","9"],["","0","⌫"]], id: \.self) { row in
                    HStack(spacing: 30) {
                        ForEach(row, id: \.self) { item in
                            Button(action: { handleTap(item) }) {
                                Text(item)
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .frame(width: 60, height: 60)
                                    .background(item.isEmpty ? Color.clear : Color.white)
                                    .cornerRadius(30)
                                    .shadow(color: .gray.opacity(0.2), radius: 3)
                            }
                            .disabled(item.isEmpty)
                        }
                    }
                }
            }
            
        }
        .padding()
        .onAppear {
            lockManager.autoCheckFaceID()
        }
    }
    
    private func handleTap(_ value: String) {
        if value == "⌫" {
            if !enteredPIN.isEmpty { enteredPIN.removeLast() }
        } else {
            if enteredPIN.count < pinLength { enteredPIN.append(value) }

            if enteredPIN.count == pinLength {
                if lockManager.verifyPIN(enteredPIN) {
                  
                    enteredPIN = ""
               
                } else {
                   
                    enteredPIN = ""
     
                }
            }
        }
    }

}

struct PINEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PINEntryView(lockManager: LockManager())
    }
}

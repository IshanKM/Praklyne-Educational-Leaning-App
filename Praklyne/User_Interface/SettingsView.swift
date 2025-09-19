import SwiftUI

struct FaceIDView: View {
    @ObservedObject var lockManager: LockManager
    @State private var newPIN = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Toggle("Enable Face ID", isOn: Binding(
                    get: { lockManager.faceIDEnabled },
                    set: { lockManager.toggleFaceID($0) }
                ))

                Toggle("Enable PIN", isOn: Binding(
                    get: { lockManager.pinEnabled },
                    set: { lockManager.togglePIN($0) }
                ))

                Section(header: Text("Set PIN")) {
                    SecureField("Enter new PIN", text: $newPIN)
                        .keyboardType(.numberPad)

                    Button("Save PIN") {
                        if newPIN.count == 4 {
                            lockManager.savePIN(newPIN)
                            newPIN = ""
                        }
                    }
                }
            }
            .navigationTitle("Security Settings")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss() 
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            })
        }
    }
}

struct FaceIDViewPreviews: PreviewProvider {
    static var previews: some View {
        FaceIDView(lockManager: LockManager())
    }
}

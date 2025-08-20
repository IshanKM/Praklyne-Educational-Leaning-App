import SwiftUI

struct SettingsView: View {
    @ObservedObject var lockManager: LockManager
    @State private var newPIN = ""

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
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(lockManager: LockManager())
    }
}

import SwiftUI

struct VideoSwipeControls: View {
    let previousAction: () -> Void
    let nextAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Button(action: previousAction) {
                Image(systemName: "chevron.up")
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
            Button(action: nextAction) {
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(Color.black.opacity(0.4))
                    .clipShape(Circle())
            }
        }
        .padding(.trailing, 20)
    }
}

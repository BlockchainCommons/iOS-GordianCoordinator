import SwiftUI

struct NoAccountSelected: View {
    var body: some View {
        VStack(spacing: 30) {
            Image.account
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .foregroundColor(.accentColor)
            Text("Select an account.")
                .bold()
        }
    }
}

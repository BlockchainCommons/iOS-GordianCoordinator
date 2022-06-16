import SwiftUI

struct AccountSetup_Preview: PreviewProvider {
    static var previews: some View {
        AccountSetup(isPresented: .constant(true)) { _ in
            // save
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

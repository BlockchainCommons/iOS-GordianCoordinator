import SwiftUI

struct AccountStatusIndicator_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AccountStatusIndicator(status: .complete)
            AccountStatusIndicator(status: .incomplete(slotsRemaining: 2))
            AccountStatusIndicator(status: .incomplete(slotsRemaining: 5))
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

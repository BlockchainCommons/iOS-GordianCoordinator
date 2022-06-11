import SwiftUI

struct AccountStatusIndicator: View {
    let status: AccountStatus
    
    var body: some View {
        switch status {
        case .incomplete(slotsRemaining: let slotsRemaining):
            ZStack {
                Group {
                    Image(systemName: "square.dashed")
                        .font(.body)
                    Text("\(slotsRemaining)")
                        .font(.caption)
                }
            }
            .foregroundColor(.yellowLightSafe)
        case .complete:
            Image(systemName: "checkmark.square.fill")
                .font(.body)
                .foregroundColor(.green)
        }
    }
}

#if DEBUG

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
#endif

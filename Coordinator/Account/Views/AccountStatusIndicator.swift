import SwiftUI

struct AccountStatusIndicator: View {
    let status: AccountStatus
    
    var body: some View {
        switch status {
        case .incomplete(slotsRemaining: let slotsRemaining):
            ZStack {
                Group {
                    Image.incompleteSlotNumbered
                        .font(.body)
                    Text("\(slotsRemaining)")
                        .font(.caption)
                }
            }
            .foregroundColor(.yellowLightSafe)
        case .complete:
            Image.completeSlot
                .font(.body)
                .foregroundColor(.green)
        }
    }
}

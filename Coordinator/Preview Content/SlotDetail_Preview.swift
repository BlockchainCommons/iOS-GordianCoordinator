import SwiftUI

struct SlotDetail_Host: View {
    @StateObject var account: DesignTimeAccount
    let slot: DesignTimeSlot
    
    init(policy: Policy) {
        let account = DesignTimeAccount(policy: policy)
        self._account = StateObject(wrappedValue: account)
        slot = DesignTimeSlot(account: account, displayIndex: 1, status: .incomplete)
    }
    
    var body: some View {
        NavigationView {
            SlotDetail(slot: slot)
                .environmentObject(Persistence(isDesignTime: true))
        }
    }
}

struct SlotDetail_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotDetail_Host(policy: .single)
                .previewDisplayName("Single")
            SlotDetail_Host(policy: .threshold(quorum: 2, slots: 3))
                .previewDisplayName("2 of 3")
        }
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
    }
}

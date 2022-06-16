import SwiftUI

struct SlotDetail_Host: View {
    @StateObject var account: DesignTimeAccount
    let slot: DesignTimeSlot
    
    init() {
        let account = DesignTimeAccount()
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
        SlotDetail_Host()
            .environmentObject(Clipboard(isDesignTime: true))
            .environmentObject(Persistence(isDesignTime: true))
    }
}

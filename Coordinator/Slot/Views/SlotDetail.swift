import SwiftUI

struct SlotDetail<Slot: SlotProtocol>: View {
    @ObservedObject var slot: Slot
    
    var body: some View {
        VStack {
            Text("Slot \(slot.displayIndex)")
            Text("\(slot.slotID.uuidString)")
        }
            .frame(maxWidth: 600)
            .navigationTitle("Slot \(slot.displayIndex)")
            .toolbar {
                AppToolbar()
            }
    }
}

#if DEBUG

struct SlotDetail_Host: View {
    @StateObject var account: DesignTimeAccount
    let slot: DesignTimeSlot
    
    init() {
        let account = DesignTimeAccount()
        self._account = StateObject(wrappedValue: account)
        slot = DesignTimeSlot(account: account, displayIndex: 1, name: "Name", status: .incomplete)
    }
    
    var body: some View {
        SlotDetail<DesignTimeSlot>(slot: slot)
    }
}

struct SlotDetail_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SlotDetail_Host()
        }
        .preferredColorScheme(.dark)
    }
}

#endif

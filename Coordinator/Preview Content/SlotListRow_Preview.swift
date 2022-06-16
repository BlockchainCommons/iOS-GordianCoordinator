import SwiftUI

struct SlotListRow_Host: View {
    @ObservedObject var slot: DesignTimeSlot
    
    init(displayIndex: Int, name: String, status: SlotStatus) {
        let account = DesignTimeAccount()
        slot = DesignTimeSlot(account: account, displayIndex: displayIndex, name: name, notes: "", status: status)
    }

    var body: some View {
        SlotListRow(slot: slot)
    }
}

struct SlotListRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotListRow_Host(displayIndex: 1, name: "", status: .incomplete)
            SlotListRow_Host(displayIndex: 2, name: "Name", status: .complete(publicKey: "Key"))
        }
        .previewLayout(.sizeThatFits)
    }
}

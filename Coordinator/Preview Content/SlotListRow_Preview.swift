import SwiftUI

struct SlotListRow_Host: View {
    @ObservedObject var slot: DesignTimeSlot
    let hideIndex: Bool
    
    init(displayIndex: Int, name: String, status: SlotStatus, hideIndex: Bool = false) {
        self.hideIndex = hideIndex
        let account = DesignTimeAccount()
        slot = DesignTimeSlot(account: account, displayIndex: displayIndex, name: name, notes: "", status: status)
    }

    var body: some View {
        SlotListRow(slot: slot, hideIndex: hideIndex)
    }
}

struct SlotListRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotListRow_Host(displayIndex: 1, name: "", status: .incomplete, hideIndex: true)
                .previewDisplayName("Hidden index")
            SlotListRow_Host(displayIndex: 1, name: "", status: .incomplete)
                .previewDisplayName("Incomplete")
            SlotListRow_Host(displayIndex: 2, name: "Name", status: .complete(randomKey()))
                .previewDisplayName("Complete")
        }
        .previewLayout(.sizeThatFits)
    }
}

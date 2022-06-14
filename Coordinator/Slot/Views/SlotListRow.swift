import SwiftUI

struct SlotListRow<Slot: SlotProtocol>: View {
    @ObservedObject var slot: Slot
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(slot.displayIndex)")
                .monospacedDigit()
            Text(Image.publicKey)
                .foregroundColor(slot.status.color)
            slot.status.icon
            VStack(alignment: .leading) {
                if slot.name.isEmpty {
                    Text(slot.status.description)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .font(.headline)
                        .foregroundColor(slot.status.color)
                } else {
                    Text(slot.name)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .font(.headline)
                    Text(slot.status.description)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(slot.status.color)
                }
            }
            Spacer()
            Image.disclosureIndicator
        }
        .font(.largeTitle)
        .foregroundColor(.primary)
        .padding()
    }
}

#if DEBUG

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
        SlotListRow_Host(displayIndex: 1, name: "", status: .incomplete)
            .previewLayout(.sizeThatFits)
        
        SlotListRow_Host(displayIndex: 2, name: "Name", status: .complete(publicKey: "Key"))
            .previewLayout(.sizeThatFits)
    }
}

#endif

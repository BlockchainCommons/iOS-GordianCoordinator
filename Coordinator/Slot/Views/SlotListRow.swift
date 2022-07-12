import SwiftUI
import BCFoundation

struct SlotListRow<Slot: SlotProtocol>: View {
    @ObservedObject var slot: Slot
    let hideIndex: Bool
    let hideDisclosure: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            index
            slot.status.icon
            title
            Spacer()
            if !hideDisclosure {
                Image.disclosureIndicator
            }
        }
        .font(.largeTitle)
        .foregroundColor(.primary)
    }

    @ViewBuilder
    var index: some View {
        if !hideIndex {
            Text("\(slot.displayIndex)")
                .monospacedDigit()
        }
    }
    
    var title: some View {
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
    }
}

#if DEBUG

struct SlotListRow_Host: View {
    @ObservedObject var slot: DesignTimeSlot
    let hideIndex: Bool
    
    init(displayIndex: Int, name: String, descriptor: OutputDescriptor?, hideIndex: Bool = false) {
        self.hideIndex = hideIndex
        let account = DesignTimeAccount()
        slot = DesignTimeSlot(account: account, displayIndex: displayIndex, name: name, notes: "", descriptor: descriptor)
    }

    var body: some View {
        SlotListRow(slot: slot, hideIndex: hideIndex, hideDisclosure: false)
    }
}

struct SlotListRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotListRow_Host(displayIndex: 1, name: "", descriptor: nil, hideIndex: true)
                .previewDisplayName("Hidden index")
            SlotListRow_Host(displayIndex: 1, name: "", descriptor: nil)
                .previewDisplayName("Incomplete")
            SlotListRow_Host(displayIndex: 2, name: "Name", descriptor: randomDescriptor())
                .previewDisplayName("Complete")
        }
        .previewLayout(.sizeThatFits)
    }
}

#endif

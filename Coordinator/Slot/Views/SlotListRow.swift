import SwiftUI

struct SlotListRow<Slot: SlotProtocol>: View {
    @ObservedObject var slot: Slot
    let hideIndex: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            index
            slot.status.icon
            title
            Spacer()
            Image.disclosureIndicator
        }
        .font(.largeTitle)
        .foregroundColor(.primary)
        .padding()
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

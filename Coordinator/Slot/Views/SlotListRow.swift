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

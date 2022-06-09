import SwiftUI

struct SlotList<Slot: SlotProtocol>: View {
    let slots: [Slot]
    
    init(slots: [Slot]) {
        self.slots = slots
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                label
                Spacer()
            }
            VStack(spacing: 0) {
                ForEach(slots) { slot in
                    NavigationLink {
                        SlotDetail(slot: slot)
                    } label: {
                        SlotListRow(displayIndex: slot.displayIndex, name: slot.name, status: slot.status)
                    }
                    if slot.id != slots.last?.id {
                        Divider()
                    }
                }
            }
            .background(Color.formGroupBackground)
            .cornerRadius(10)
        }
    }
    
    var label: some View {
        Label {
            Text("Slots")
                .bold()
        } icon: {
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
        }
    }
}

#if DEBUG

struct SlotList_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotList(slots: [
                DesignTimeSlot(displayIndex: 1, name: "Name", status: .incomplete),
                DesignTimeSlot(displayIndex: 2, name: "", status: .incomplete),
                DesignTimeSlot(displayIndex: 3, name: "Name", status: .complete(publicKey: ""))
            ])
        }
        .frame(width: 400)
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
#endif

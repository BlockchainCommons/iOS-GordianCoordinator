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

struct SlotList_Host: View {
    @StateObject var account: DesignTimeAccount
    let slots: [DesignTimeSlot]
    
    init() {
        let account = DesignTimeAccount()
        self._account = StateObject(wrappedValue: account)
        slots = [
            .init(account: account, displayIndex: 1, name: "Slot 1", status: .incomplete),
            .init(account: account, displayIndex: 2, name: "", status: .complete(publicKey: "key")),
            .init(account: account, displayIndex: 3, name: "", status: .incomplete)
        ]
    }
    
    var body: some View {
        SlotList(slots: slots)
    }
}

struct SlotList_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotList_Host()
        }
        .frame(width: 400)
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

#endif

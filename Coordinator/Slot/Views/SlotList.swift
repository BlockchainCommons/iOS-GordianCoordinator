import SwiftUI

struct SlotList<Account, Slot>: View where Account: AccountProtocol, Slot == Account.Slot
{
    @ObservedObject var account: Account
    var slots: [Slot] {
        account.slots
    }
    let onValid: () -> Void
    
    init(account: Account, onValid: @escaping () -> Void) {
        self.account = account
        self.onValid = onValid
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
                        SlotDetail(slot: slot, getClipboard: { nil }, onValid: onValid)
                    } label: {
                        SlotListRow(slot: slot)
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
            Image.slot
        }
    }
}

#if DEBUG

struct SlotList_Host: View {
    @StateObject var account: DesignTimeAccount
    
    init() {
        let account = DesignTimeAccount()
        self._account = StateObject(wrappedValue: account)
        account.slots = [
            .init(account: account, displayIndex: 1, name: "Foo", status: .incomplete),
            .init(account: account, displayIndex: 2, name: "Bar", status: .complete(publicKey: "key")),
            .init(account: account, displayIndex: 3, name: "", status: .incomplete),
            .init(account: account, displayIndex: 4, name: "", status: .complete(publicKey: "key"))
        ]
    }
    
    var body: some View {
        SlotList(account: account) {
            // onValid
        }
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

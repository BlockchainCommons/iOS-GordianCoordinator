import SwiftUI
import WolfSwiftUI

struct SlotList<Account, Slot>: View
where
    Account: AccountProtocol,
    Slot == Account.Slot
{
    @ObservedObject var account: Account
    
    var slots: [Slot] {
        account.slots
    }
    
    init(account: Account) {
        self.account = account
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
                        LazyView(SlotDetail(slot: slot))
                    } label: {
                        SlotListRow(slot: slot, hideIndex: slots.count == 1, hideDisclosure: false)
                            .padding()
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
        SectionLabel("Slots", icon: .slot)
    }
}

#if DEBUG

struct SlotList_Host: View {
    @StateObject var account: DesignTimeAccount
    
    init() {
        let account = DesignTimeAccount()
        self._account = StateObject(wrappedValue: account)
        account.slots = [
            .init(account: account, displayIndex: 1, name: "Foo", descriptor: nil),
            .init(account: account, displayIndex: 2, name: "Bar", descriptor: randomDescriptor()),
            .init(account: account, displayIndex: 3, name: "", descriptor: nil),
            .init(account: account, displayIndex: 4, name: "", descriptor: randomDescriptor())
        ]
        account.updateStatus()
    }
    
    var body: some View {
        NavigationView {
            SlotList(account: account)
        }
    }
}

struct SlotList_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotList_Host()
        }
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
        .frame(width: 400)
        .padding()
    }
}

#endif

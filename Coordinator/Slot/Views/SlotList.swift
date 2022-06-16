import SwiftUI

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
                        SlotDetail(slot: slot)
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
        SectionLabel("Slots", icon: .slot)
    }
}

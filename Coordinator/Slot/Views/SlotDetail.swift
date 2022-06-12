import SwiftUI
import BCApp

struct SlotDetail<Slot: SlotProtocol>: View
{
    @ObservedObject var slot: Slot
    @FocusState var focusedField: UUID?
    let getClipboard: () -> String?
    let onValid: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                accountIdentity
                key
                name
                notes
            }
        }
        .frame(maxWidth: 600)
        .padding()
        .navigationTitle("Slot \(slot.displayIndex)")
        .navigationBarBackButtonHidden(false)
        .toolbar {
            KeyboardToolbar {
                focusedField = nil
            }

            AppToolbar()
        }
    }
    
    var accountIdentity: some View {
        ObjectIdentityBlock(model: .constant(slot.account))
            .frame(height: 80)
    }
    
    var key: some View {
        KeyEditor(slot: slot, getClipboard: getClipboard)
    }

    @ViewBuilder
    var name: some View {
        NameEditor($slot.name, focusedField: _focusedField) {
            onValid()
        }
    }

    var notes: some View {
        NotesEditor($slot.notes, focusedField: _focusedField) {
            onValid()
        }
    }
}

#if DEBUG

struct SlotDetail_Host: View {
    @StateObject var account: DesignTimeAccount
    let slot: DesignTimeSlot
    
    init() {
        let account = DesignTimeAccount()
        self._account = StateObject(wrappedValue: account)
        slot = DesignTimeSlot(account: account, displayIndex: 1, status: .incomplete)
    }
    
    var body: some View {
        SlotDetail(slot: slot, getClipboard: { nil }, onValid: { })
    }
}

struct SlotDetail_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SlotDetail_Host()
        }
        .preferredColorScheme(.dark)
    }
}

#endif

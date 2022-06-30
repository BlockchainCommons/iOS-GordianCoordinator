import SwiftUI
import BCApp

struct SlotDetail<Slot: SlotProtocol>: View
{
    @ObservedObject var slot: Slot
    @FocusState var focusedField: UUID?
    @EnvironmentObject var clipboard: Clipboard
    @EnvironmentObject var persistence: Persistence
    @State var name: String = ""
    @State var notes: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                accountIdentity
                key
                nameEditor
                notesEditor
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
        .onAppear {
            self.name = slot.name
            self.notes = slot.notes
        }
    }
    
    func onValid() {
        slot.name = name
        slot.notes = notes
        persistence.saveChanges()
    }

    var accountIdentity: some View {
        ObjectIdentityBlock(model: .constant(slot.account))
            .frame(height: 80)
    }
    
    var key: some View {
        DescriptorEditor(slot: slot)
    }

    @ViewBuilder
    var nameEditor: some View {
        NameEditor($name, focusedField: _focusedField, onValid: onValid)
    }

    var notesEditor: some View {
        NotesEditor($notes, focusedField: _focusedField, onValid: onValid)
    }
}

#if DEBUG

struct SlotDetail_Host: View {
    @StateObject var account: DesignTimeAccount
    let slot: DesignTimeSlot
    
    init(policy: Policy) {
        let account = DesignTimeAccount(policy: policy)
        account.slots.first?.descriptor = randomDescriptor()
        account.updateStatus()
        self._account = StateObject(wrappedValue: account)
        slot = account.slots.first!
    }
    
    var body: some View {
        NavigationView {
            SlotDetail(slot: slot)
                .environmentObject(Persistence(isDesignTime: true))
        }
    }
}

struct SlotDetail_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotDetail_Host(policy: .single)
                .previewDisplayName("Single")
            SlotDetail_Host(policy: .threshold(quorum: 2, slots: 3))
                .previewDisplayName("2 of 3")
        }
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
        .preferredColorScheme(.dark)
    }
}

#endif

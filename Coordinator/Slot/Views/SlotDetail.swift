import SwiftUI
import BCApp

struct SlotDetail<Slot: SlotProtocol>: View
{
    @ObservedObject var slot: Slot
    @FocusState var focusedField: UUID?
    @EnvironmentObject var clipboard: Clipboard
    @EnvironmentObject var persistence: Persistence

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
        KeyEditor(slot: slot)
    }

    @ViewBuilder
    var name: some View {
        NameEditor($slot.name, focusedField: _focusedField) {
            persistence.saveChanges()
        }
    }

    var notes: some View {
        NotesEditor($slot.notes, focusedField: _focusedField) {
            persistence.saveChanges()
        }
    }
}

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
        KeyEditor(slot: slot)
    }

    @ViewBuilder
    var nameEditor: some View {
        NameEditor($name, focusedField: _focusedField, onValid: onValid)
    }

    var notesEditor: some View {
        NotesEditor($notes, focusedField: _focusedField, onValid: onValid)
    }
}

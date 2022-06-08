import SwiftUI
import BCApp

struct NotesEditor: View {
    @Binding var notes: String
    @FocusState var focusedField: UUID?
    @State var myID = UUID()
    
    init(_ notes: Binding<String>, focusedField: FocusState<UUID?>) {
        self._notes = notes
        self._focusedField = focusedField
    }

    var body: some View {
        VStack(alignment: .leading) {
            label
            field
        }
    }
    
    var label: some View {
        Label {
            Text("Notes")
                .bold()
        } icon: {
            Image.note
        }
    }
    
    var field: some View {
        TextEditor(text: $notes)
            .formSectionStyle()
            .frame(minHeight: 100, idealHeight: 200)
            .id("notes")
            .accessibility(label: Text("Notes Field"))
            .focused($focusedField, equals: myID)
    }
}

#if DEBUG

class NoteEditorSubject: ObservableObject {
    @Published var note: String = "Hello"
}

struct NoteEditorHost: View {
    @StateObject var subject = NoteEditorSubject()
    @FocusState var focusedField: UUID?

    var body: some View {
        NotesEditor($subject.note, focusedField: _focusedField)
    }
}

struct NoteEditor_Preview: PreviewProvider {
    static var previews: some View {
        NoteEditorHost()
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

#endif

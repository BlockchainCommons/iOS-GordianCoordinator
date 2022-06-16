import SwiftUI

class NoteEditorSubject: ObservableObject {
    @Published var note: String = "Hello"
}

struct NoteEditorHost: View {
    @StateObject var subject = NoteEditorSubject()
    @FocusState var focusedField: UUID?

    var body: some View {
        NotesEditor($subject.note, focusedField: _focusedField) {
            // onValid
        }
    }
}

struct NoteEditor_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NoteEditorHost()
        }
        .padding()
        .previewLayout(.fixed(width: 400, height: 300))
        .preferredColorScheme(.dark)
    }
}

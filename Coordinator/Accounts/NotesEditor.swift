import SwiftUI
import BCApp
import Combine

struct NotesEditor: View {
    @Binding var notes: String
    @Binding var isValid: Bool
    @FocusState var focusedField: UUID?
    let onValid: () -> Void
    @State var myID = UUID()
    @StateObject private var validator = Validator()

    init(_ notes: Binding<String>, isValid: Binding<Bool>, focusedField: FocusState<UUID?>, onValid: @escaping () -> Void) {
        self._notes = notes
        self._focusedField = focusedField
        self._isValid = isValid
        self.onValid = onValid
    }

    var body: some View {
        VStack(alignment: .leading) {
            label
            field
        }
        .onAppear {
            self.validator.subject.send(notes)
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
            .onChange(of: notes) { newValue in
                validator.subject.send(newValue)
            }
            .onReceive(validator.publisher) {
                isValid = $0.isValid
                if isValid {
                    onValid()
                }
            }
            .validation(validator.publisher)
    }

    class Validator: ObservableObject {
        let subject = PassthroughSubject<String, Never>()
        let publisher: ValidationPublisher
        
        init() {
            publisher = subject
                .debounceField()
                .validate()
        }
    }
}

#if DEBUG

class NoteEditorSubject: ObservableObject {
    @Published var note: String = "Hello"
}

struct NoteEditorHost: View {
    @StateObject var subject = NoteEditorSubject()
    @FocusState var focusedField: UUID?
    @State var isValid: Bool = true

    var body: some View {
        NotesEditor($subject.note, isValid: $isValid, focusedField: _focusedField) {
            // onValid
        }
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

import SwiftUI
import BCApp
import Combine

struct NotesEditor: View {
    @Binding var notes: String
    var isValid: Binding<Bool>?
    @FocusState var focusedField: UUID?
    let onValid: (() -> Void)?
    @State var myID = UUID()
    @StateObject private var validator = Validator()

    init(_ notes: Binding<String>, isValid: Binding<Bool>? = nil, focusedField: FocusState<UUID?>, onValid: (() -> Void)? = nil) {
        self._notes = notes
        self._focusedField = focusedField
        self.isValid = isValid
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
        SectionLabel("Notes", icon: .note)
    }

    @ViewBuilder
    var field: some View {
        if #available(iOS 16, macOS 14, *) {
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(...5)
                .formSectionStyle()
                .id("notes")
                .accessibility(label: Text("Notes Field"))
                .focused($focusedField, equals: myID)
                .onChange(of: notes) { newValue in
                    validator.subject.send(newValue)
                }
                .onReceive(validator.publisher) {
                    if let isValid = isValid {
                        isValid.wrappedValue = $0.isValid
                    }
                    if let onValid = onValid, $0.isValid {
                        onValid()
                    }
                }
                .validation(validator.publisher)
        } else {
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
                    if let isValid = isValid {
                        isValid.wrappedValue = $0.isValid
                    }
                    if let onValid = onValid, $0.isValid {
                        onValid()
                    }
                }
                .validation(validator.publisher)
        }
    }

//    TextField("Notes", text: $notes, axis: .vertical)
//        .lineLimit(...5)
//        .formSectionStyle()
//        .id("notes")

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

import SwiftUI
import BCApp
import Combine

struct NameEditor: View {
    @Binding var name: String
    @Binding var isValid: Bool
    @FocusState var focusedField: UUID?
    let generateName: () -> String
    @State private var isEditing: Bool = false
    @StateObject private var validator = Validator()
    @State var myID = UUID()
    
    init(_ name: Binding<String>, isValid: Binding<Bool>, focusedField: FocusState<UUID?>, generateName: @escaping () -> String) {
        self._name = name
        self._focusedField = focusedField
        self.generateName = generateName
        self._isValid = isValid
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            label
            field
        }
        .onAppear {
            self.validator.subject.send(name)
        }
    }
    
    var label: some View {
        Label {
            Text("Name")
                .bold()
        } icon: {
            Image.name
        }
    }
    
    var field: some View {
        HStack {
            TextField("Name", text: $name) { isEditing in
                withAnimation {
                    self.isEditing = isEditing
                }
            }
            .focused($focusedField, equals: myID)
            .accessibility(label: Text("Name Field"))
            if !isEditing {
                menu
            }
        }
        .onChange(of: name) { newValue in
            validator.subject.send(newValue)
        }
        .onReceive(validator.publisher) {
            isValid = $0.isValid
        }
        .formSectionStyle()
        .validation(validator.publisher)
        .font(.body)
    }
    
    var menu: some View {
        Menu {
            RandomizeMenuItem() {
                name = generateName()
            }
            ClearMenuItem() {
                name = ""
            }
        } label: {
            Image.menu
                .foregroundColor(.secondary)
                .font(.title3)
        }
        .accessibility(label: Text("Name Menu"))
    }

    class Validator: ObservableObject {
        let subject = PassthroughSubject<String, Never>()
        let publisher: ValidationPublisher
        
        init() {
            publisher = subject
                .debounceField()
                .validateNotEmpty("Name may not be empty.")
        }
    }
}

#if DEBUG

import WolfLorem

class NameEditorSubject: ObservableObject {
    @Published var name: String = "Hello"
}

struct NameEditorHost: View {
    @StateObject var subject = NameEditorSubject()
    @FocusState var focusedField: UUID?
    @State var isValid: Bool = true

    var body: some View {
        NameEditor($subject.name, isValid: $isValid, focusedField: _focusedField) {
            Lorem.bytewords(4)
        }
    }
}

struct NameEditor_Preview: PreviewProvider {
    static var previews: some View {
        NameEditorHost()
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

#endif

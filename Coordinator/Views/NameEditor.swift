import SwiftUI
import BCApp
import Combine

struct NameEditor: View {
    @Binding var name: String
    var isValid: Binding<Bool>?
    var focusedField: FocusState<UUID?>?
    let onValid: (() -> Void)?
    let generateName: (() -> String)?
    @State private var isEditing: Bool = false
    @StateObject private var validator: Validator
    @State var myID = UUID()
    
    init(_ name: Binding<String>, isValid: Binding<Bool>? = nil, focusedField: FocusState<UUID?>? = nil, onValid: (() -> Void)? = nil, generateName: (() -> String)? = nil) {
        self._name = name
        self.focusedField = focusedField
        self.onValid = onValid
        self.generateName = generateName
        let shouldValidate: Bool
        if let isValid = isValid {
            self.isValid = isValid
            shouldValidate = true
        } else {
            shouldValidate = false
        }
        self._validator = StateObject(wrappedValue: Validator(shouldValidate: shouldValidate))
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
        SectionLabel("Name", icon: .name)
    }
    
    var field: some View {
        HStack {
            TextField("Name", text: $name) { isEditing in
                withAnimation {
                    self.isEditing = isEditing
                }
            }
            .if(focusedField != nil) {
                $0.focused(focusedField!.projectedValue, equals: myID)
            }
            .accessibility(label: Text("Name Field"))
            if !isEditing {
                menu
            }
        }
        .formSectionStyle()
        .font(.body)
        .onChange(of: name) { newValue in
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
    
    @ViewBuilder
    var menu: some View {
        if let generateName = generateName {
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
        } else {
            Button {
                name = ""
            } label: {
                Image.clearField
            }
            .foregroundColor(.secondary)
            .font(.title3)
            .accessibility(label: Text("Clear Name"))
            .opacity(name.isEmpty ? 0 : 1)
        }
    }

    class Validator: ObservableObject {
        let subject = PassthroughSubject<String, Never>()
        let publisher: ValidationPublisher
        
        init(shouldValidate: Bool) {
            if shouldValidate {
                publisher = subject
                    .debounceField()
                    .validateNotEmpty("Name may not be empty.")
            } else {
                publisher = subject
                    .debounceField()
                    .validate()
            }
        }
    }
}

#if DEBUG

import WolfLorem

class NameEditorSubject: ObservableObject {
    @Published var name: String = "Hello"
}

struct NameEditorHost: View {
    let validate: Bool
    let generatesName: Bool
    @StateObject var subject = NameEditorSubject()
    @State var isValid: Bool = true

    var body: some View {
        NameEditor($subject.name, isValid: validate ? $isValid : nil, generateName: generatesName ? generateName : nil)
    }
    
    func generateName() -> String {
        Lorem.bytewords(4)
    }
}

struct NameEditor_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Text("Validates:")
                    .foregroundColor(.secondary)
                    .font(.caption)
                NameEditorHost(validate: true, generatesName: true)
            }
            VStack {
                Text("Doesn't validate:")
                    .foregroundColor(.secondary)
                    .font(.caption)
                NameEditorHost(validate: false, generatesName: true)
            }
            VStack {
                Text("Doesn't validate or generate name:")
                    .foregroundColor(.secondary)
                    .font(.caption)
                NameEditorHost(validate: false, generatesName: false)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
#endif

import SwiftUI
import BCApp
import Combine
import WolfLorem

struct KeyEditor<Slot: SlotProtocol>: View {
    @ObservedObject var slot: Slot
    let getClipboard: () -> String?
    @StateObject private var validator = Validator()
    @State var key: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            labelRow
            keyRow
        }
        .onChange(of: key) { newValue in
            validator.subject.send(newValue)
        }
        .onReceive(validator.publisher) {
            if $0.isValid {
                slot.status = .complete(publicKey: key!)
            }
        }
        .onAppear {
            self.key = slot.key
        }
    }
    
    var labelRow: some View {
        HStack {
            label
            Spacer()
            status
                .font(Font.title3.bold())
        }
    }
    
    var label: some View {
        Label {
            Text("Public Key")
                .bold()
        } icon: {
            Image.publicKey
        }
    }
    
    @ViewBuilder
    var status: some View {
        switch slot.status {
        case .incomplete:
            Image.incompleteSlot
                .foregroundColor(.yellowLightSafe)
        case .complete:
            Image.completeSlot
                .foregroundColor(.green)
        }
    }
    
    @ViewBuilder
    var keyRow: some View {
        switch slot.status {
        case .incomplete:
            importMenu
        case .complete:
            Text("Complete")
        }
    }
    
    var importMenu: some View {
        Menu {
            Button(action: pasteKey) {
                Label {
                    Text("Paste from Clipboard")
                } icon: {
                    Image.paste
                }
            }
        } label: {
            Button { } label: {
                Label {
                    Text("Import")
                } icon: {
                    Image.menu
                }
                .font(Font.body.bold())
            }
            .buttonStyle(.borderedProminent)
        }
        .validation(validator.publisher)
    }
    
    func pasteKey() {
        key = getClipboard()
    }
    
    class Validator: ObservableObject {
        let subject = PassthroughSubject<String?, Never>()
        let publisher: ValidationPublisher
        
        init() {
            publisher = subject
                .debounceField()
                .validateKey()
        }
    }
}

func isValidKey(_ key: String?) -> Bool {
    guard let key = key else {
        return false
    }
    return key.count > 4
}

extension Publisher where Output == String? {
    public func isValidKey() -> Publishers.Map<Self, Bool> {
        map { Coordinator.isValidKey($0) }
    }
    
    public func validateKey(_ key: String? = nil) -> ValidationPublisher where Failure == Never {
        isValidKey().map {
            $0 ? .valid : .invalid("Not a valid key.")
        }
        .eraseToAnyPublisher()
    }
}

#if DEBUG

struct KeyEditor_Host: View {
    @StateObject var slot: DesignTimeSlot
    @State var clipboard: String?
    
    var body: some View {
        VStack {
            KeyEditor(slot: slot) {
                clipboard
            }
            HStack {
                Button {
                    clipboard = "foobar"
                } label: {
                    Text("Copy Valid")
                }
                .buttonStyle(.borderless)
                .font(.caption)

                Button {
                    clipboard = "foo"
                } label: {
                    Text("Copy Invalid")
                }
                .buttonStyle(.borderless)
                .font(.caption)

                Spacer()
            }
            .padding()
        }
    }
}

struct KeyEditor_Preview: PreviewProvider {
    static var previews: some View {
        KeyEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(), displayIndex: 1, name: "Name", notes: "Notes", status: .incomplete))
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

#endif

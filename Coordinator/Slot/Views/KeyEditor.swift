import SwiftUI
import BCApp
import Combine
import WolfLorem
import BCFoundation
import WolfBase

struct KeyEditor<Slot: SlotProtocol>: View
{
    @ObservedObject var slot: Slot
    @EnvironmentObject var persistence: Persistence
    @StateObject private var validator = Validator()
    @State var key: String? {
        didSet {
            validator.subject.send(key)
        }
    }
    @State var isAlertPresented: Bool = false
    @EnvironmentObject var clipboard: Clipboard

    var status: SlotStatus {
        get {
            slot.status
        }
    }
    
    func setStatus(_ status: SlotStatus) {
        withAnimation {
            slot.status = status
            slot.account.updateStatus()
            persistence.saveChanges()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            labelRow
            keyRow
        }
        .onReceive(validator.publisher) {
            if $0.isValid {
                setStatus(.complete(publicKey: key!))
            }
        }
    }
    
    var labelRow: some View {
        HStack {
            label
            Spacer()
            statusIndicator
                .font(Font.title2.bold())
        }
    }
    
    var label: some View {
        SectionLabel("Public Key", icon: .publicKey)
    }
    
    @ViewBuilder
    var statusIndicator: some View {
        switch status {
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
        switch status {
        case .incomplete:
            importMenu
        case .complete:
            HStack {
                keyHolder
                optionsMenu
            }
        }
    }
    
    var keyHolder: some View {
        Text(slot.key!)
            .font(.caption)
            .monospaced()
            .lineLimit(3)
            .formSectionStyle(isVisible: true)
    }
    
    var optionsMenu: some View {
        Menu {
            Button {
                clipboard.string = slot.key
            } label: {
                Label {
                    Text("Copy to Clipboard")
                } icon: {
                    Image.copy
                }
            }
            
            Button(role: .destructive) {
                isAlertPresented = true
            } label: {
                Label("Remove Key", icon: .clear)
            }
        } label: {
            Button { } label: {
                Image.menu
                    .font(Font.title3.bold())
                    .foregroundColor(.secondary)
            }
        }
        .alert("Remove Key", isPresented: $isAlertPresented) {
            Button(role: .destructive) {
                setStatus(.incomplete)
            } label: {
                Text("Remove")
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This is not undoable.")
        }
    }
    
    var importMenu: some View {
        Menu {
            Button {
                key = clipboard.string
            } label: {
                Label {
                    Text("Paste from Clipboard")
                } icon: {
                    Image.paste
                }
            }
            #if DEBUG
            Button {
                key = randomKey()
            } label: {
                Label {
                    Text("Random Key")
                } icon: {
                    Image.randomize
                }
            }
            #endif
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

fileprivate func isValidKey(_ key: String?) -> Bool {
    guard
        let key = key,
        let _ = try? HDKey(base58: key)
    else {
        return false
    }
    return true
}

extension Publisher where Output == String? {
    public func isValidKey() -> Publishers.Map<Self, Bool> {
        map {
            Coordinator.isValidKey($0)
        }
    }
    
    public func validateKey(_ key: String? = nil) -> ValidationPublisher where Failure == Never {
        isValidKey().map {
            $0 ? .valid : .invalid("Not a valid key.")
        }
        .eraseToAnyPublisher()
    }
}

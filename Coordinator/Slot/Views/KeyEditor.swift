import SwiftUI
import BCApp
import Combine
import WolfLorem
import BCFoundation
import WolfBase

struct KeyEditor<Slot: SlotProtocol>: View
{
    @ObservedObject var slot: Slot
    @StateObject private var validator = Validator()
    @State var key: String?
    @State var isAlertPresented: Bool = false
    @EnvironmentObject var clipboard: Clipboard

    var status: SlotStatus {
        get {
            slot.status
        }
    }
    
    func setStatus(_ status: SlotStatus) {
        slot.status = status
//        slot.account.updateStatus()
    }
    
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
                setStatus(.complete(publicKey: key!))
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
            .monospaced()
            .lineLimit(1)
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

#if DEBUG

struct KeyEditor_Host: View {
    @StateObject var slot: DesignTimeSlot
    @EnvironmentObject var clipboard: Clipboard
    
    var body: some View {
        VStack {
            KeyEditor(slot: slot)
            if !slot.isComplete {
                HStack {
                    Text("Clipboard:")
                    Button {
                        clipboard.string = randomKey()
                    } label: {
                        Text("Valid")
                    }

                    Button {
                        clipboard.string = "invalid key"
                    } label: {
                        Text("Invalid")
                    }

                    Button {
                        clipboard.string = nil
                    } label: {
                        Text("Clear")
                    }

                    Spacer()
                }
                .buttonStyle(.borderless)
                .font(.caption)
                .padding()
            }
        }
    }
}

struct KeyEditor_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            KeyEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(), displayIndex: 1, name: "Name", notes: "Notes", status: .incomplete))
            KeyEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(), displayIndex: 1, name: "Name", notes: "Notes", status: .complete(publicKey: randomKey())))
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(Clipboard(isDesignTime: true))
        .padding()
    }
}

func randomKey() -> String {
    let seed = Seed()
    let hdKey = try! HDKey(seed: seed)
    let publicKey = hdKey.public
    return publicKey.base58
}

#endif

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
            validator.subject.send((key, slot.acceptedDataTypes))
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
                setStatus(.complete(key!))
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
        SectionLabel("Value", icon: .slot)
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
            VStack(alignment: .leading){
                importMenu
                note
            }
        case .complete:
            HStack {
                keyHolder
                optionsMenu
            }
        }
    }
    
    var note: some View {
        Text("Accepted types: " + slot.acceptedDataTypes.map({$0.description.capitalized}).sorted().formatted(.list(type: .or)))
            .font(.caption)
    }
    
    var keyHolder: some View {
        Text(slot.key!)
            .font(Font.caption.monospaced())
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
                Label("Remove", icon: .clear)
            }
        } label: {
            Button { } label: {
                Image.menu
                    .font(Font.title3.bold())
                    .foregroundColor(.secondary)
            }
        }
        .alert("Remove Value", isPresented: $isAlertPresented) {
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
            Button {
                key = randomDescriptor()
            } label: {
                Label {
                    Text("Random Descriptor")
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
        let subject = PassthroughSubject<(String?, Set<SlotDataType>), Never>()
        let publisher: ValidationPublisher
        
        init() {
            publisher = subject
                .debounceField()
                .validateSlotValue()
        }
    }
}

fileprivate extension Publisher where Output == (String?, Set<SlotDataType>) {
    func isValidValue() -> Publishers.Map<Self, Bool> {
        map { (value, acceptedTypes) in
            if
                acceptedTypes.contains(.key),
                Coordinator.isValidKey(value)
            {
                return true
            }
            if acceptedTypes.contains(.descriptor),
               Coordinator.isValidDescriptor(value)
            {
                return true
            }
            return false
        }
    }
    
    func validateSlotValue() -> ValidationPublisher where Failure == Never {
        isValidValue().map {
            $0 ? .valid : .invalid("Not a valid value.")
        }
        .eraseToAnyPublisher()
    }
}

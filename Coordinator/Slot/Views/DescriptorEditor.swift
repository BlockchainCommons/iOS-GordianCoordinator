import SwiftUI
import BCApp
import Combine
import WolfLorem
import WolfBase
import BCApp

struct DescriptorEditor<Slot: SlotProtocol>: View
{
    @ObservedObject var slot: Slot
    @EnvironmentObject var persistence: Persistence
    @StateObject private var validator = Validator()
    @State var descriptorSource: String? {
        didSet {
            validator.subject.send(descriptorSource)
        }
    }
    @State var isAlertPresented: Bool = false
    @State var isSheetPresented: Bool = false
    @EnvironmentObject var clipboard: Clipboard

    var descriptor: OutputDescriptor? {
        slot.descriptor
    }
    
    func setDescriptor(_ descriptor: OutputDescriptor?) {
        withAnimation {
            slot.descriptor = descriptor
            slot.account.updateStatus()
            persistence.saveChanges()
        }
    }
    
    var isComplete: Bool {
        descriptor != nil
    }

    var body: some View {
        VStack(alignment: .leading) {
            labelRow
            descriptorRow
        }
        .onAppear {
            descriptorSource = slot.descriptor?.sourceWithChecksum
        }
        .onReceive(validator.publisher) {
            if $0.isValid {
                setDescriptor(try! OutputDescriptor(descriptorSource!))
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
        SectionLabel("Descriptor", icon: .outputDescriptor)
    }
    
    @ViewBuilder
    var statusIndicator: some View {
        if isComplete {
            Image.completeSlot
                .foregroundColor(.green)
        } else {
            Image.incompleteSlot
                .foregroundColor(.yellowLightSafe)
        }
    }
    
    @ViewBuilder
    var descriptorRow: some View {
        if isComplete {
            HStack {
                descriptorHolder
                optionsMenu
            }
        } else {
            HStack {
                importMenu
                displayRequestButton
            }
            .validation(validator.publisher)
        }
    }
    
    var displayRequestButton: some View {
        Button {
            isSheetPresented = true
        } label: {
            Label {
                Text("Request")
            } icon: {
                Image.displayQRCode
            }
        }
        .buttonStyle(.bordered)
        .sheet(isPresented: $isSheetPresented) {
            DisplayTransaction(
                isPresented: $isSheetPresented,
                isSensitive: false,
                ur: slot.outputDescriptorRequest.ur,
                title: "Descriptor Request",
                caption: "You are requesting another party to provide an output descriptor for this slot."
            ) {
                Rebus {
                    Asset.btc.icon
                    slot.account.network.icon
                    Symbol.outputDescriptor
                    Image.questionmark
                }
            }
        }
    }
    
    var descriptorHolder: some View {
        Text(descriptorSource ?? "")
            .font(Font.caption.monospaced())
            .lineLimit(5)
            .formSectionStyle(isVisible: true)
    }
    
    var optionsMenu: some View {
        Menu {
            Button {
                clipboard.string = slot.descriptor!.sourceWithChecksum
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
                setDescriptor(nil)
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
                descriptorSource = clipboard.string
            } label: {
                Label {
                    Text("Paste from Clipboard")
                } icon: {
                    Image.paste
                }
            }
            #if DEBUG
            Button {
                descriptorSource = randomDescriptor().sourceWithChecksum
            } label: {
                Label {
                    Text("Random Descriptor")
                } icon: {
                    Image.developer
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
            .buttonStyle(.bordered)
        }
    }
    
    class Validator: ObservableObject {
        let subject = PassthroughSubject<String?, Never>()
        let publisher: ValidationPublisher
        
        init() {
            publisher = subject
                .dropFirst()
                .debounceField()
                .validateSlotValue()
        }
    }
}

fileprivate extension Publisher where Output == String? {
    func isValidValue() -> Publishers.Map<Self, Bool> {
        map { value in
            Coordinator.isValidDescriptor(value)
        }
    }
    
    func validateSlotValue() -> ValidationPublisher where Failure == Never {
        isValidValue().map {
            $0 ? .valid : .invalid("Not a valid descriptor.")
        }
        .eraseToAnyPublisher()
    }
}

#if DEBUG

struct DescriptorEditor_Host: View {
    @StateObject var slot: DesignTimeSlot
    @EnvironmentObject var clipboard: Clipboard
    
    var body: some View {
        VStack(alignment: .leading) {
            DescriptorEditor(slot: slot)
            Spacer()
            ClipboardView()
            HStack {
                Text("Clipboard:")
                Button {
                    clipboard.string = randomKey()
                } label: {
                    Text("Key")
                }

                Button {
                    clipboard.string = randomDescriptor().sourceWithChecksum
                } label: {
                    Text("Descriptor")
                }

                Button {
                    clipboard.string = "invalid"
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
        }
        .padding()
        .frame(maxHeight: 800)
    }
}

struct DescriptorEditor_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            DescriptorEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(policy: .single), displayIndex: 1, name: "Name", notes: "Notes", descriptor: nil))
                .previewDisplayName("Single")
            DescriptorEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(policy: .threshold(quorum: 2, slots: 3)), displayIndex: 1, name: "Name", notes: "Notes", descriptor: randomDescriptor()))
                .previewDisplayName("2 of 3")
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
        .darkMode()
    }
}

#endif

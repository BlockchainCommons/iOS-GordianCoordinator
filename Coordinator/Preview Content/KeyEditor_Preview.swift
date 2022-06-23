import SwiftUI
import BCFoundation

struct KeyEditor_Host: View {
    @StateObject var slot: DesignTimeSlot
    @EnvironmentObject var clipboard: Clipboard
    
    var body: some View {
        VStack(alignment: .leading) {
            KeyEditor(slot: slot)
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
                    clipboard.string = randomDescriptor()
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
        .frame(maxHeight: 300)
    }
}

struct KeyEditor_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            KeyEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(policy: .single), displayIndex: 1, name: "Name", notes: "Notes", status: .incomplete))
                .previewDisplayName("Single")
            KeyEditor_Host(slot: DesignTimeSlot(account: DesignTimeAccount(policy: .threshold(quorum: 2, slots: 3)), displayIndex: 1, name: "Name", notes: "Notes", status: .complete(randomKey())))
                .previewDisplayName("2 of 3")
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
    }
}

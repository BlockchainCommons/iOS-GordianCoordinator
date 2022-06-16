import SwiftUI
import BCFoundation

struct KeyEditor_Host: View {
    @StateObject var slot: DesignTimeSlot
    @EnvironmentObject var clipboard: Clipboard
    
    var body: some View {
        NavigationView {
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
                }
                Spacer()
                ClipboardView()
            }
            .padding()
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
        .environmentObject(Persistence(isDesignTime: true))
    }
}

func randomKey() -> String {
    let seed = Seed()
    let hdKey = try! HDKey(seed: seed)
    let publicKey = hdKey.public
    return publicKey.base58
}

import SwiftUI

struct SlotDetail<Slot: SlotProtocol>: View {
    let slot: Slot
    
    var body: some View {
        Text("Slot \(slot.displayIndex)")
            .frame(maxWidth: 600)
            .navigationTitle("Slot \(slot.displayIndex)")
            .toolbar {
                AppToolbar()
            }
    }
}

import SwiftUI
import BCApp

struct PolicyPicker: View {
    @Binding var selectedPreset: PolicyPreset?
    let presets = PolicyPreset.allCases
    
    var body: some View {
        VStack(alignment: .leading) {
            label
            picker
            note
        }
    }
    
    var label: some View {
        SectionLabel("Policy", icon: Image.policy)
    }
    
    var note: some View {
        Text("A “Single” policy may hold a single key or output descriptor. The other policies hold three or more keys.")
            .font(.caption)
    }
    
    var picker: some View {
        SegmentPicker(selection: $selectedPreset, segments: .constant(presets))
    }
}

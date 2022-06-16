import SwiftUI
import BCApp

struct PolicyPicker: View {
    @Binding var selectedPreset: PolicyPreset?
    let presets = PolicyPreset.allCases
    
    var body: some View {
        VStack(alignment: .leading) {
            label
            picker
        }
    }
    
    var label: some View {
        SectionLabel("Policy", icon: Image.policy)
    }
    
    var picker: some View {
        SegmentPicker(selection: $selectedPreset, segments: .constant(presets))
    }
}

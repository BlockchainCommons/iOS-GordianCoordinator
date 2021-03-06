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

#if DEBUG

class PolicyPicker_Model: ObservableObject {
    @Published var policy: PolicyPreset = .threshold2of3
}

struct PolicyPicker_Host: View {
    @StateObject var model = PolicyPicker_Model()
    
    var body: some View {
        VStack {
            PolicyPicker(selectedPreset: Binding($model.policy))
                .padding()
            Text("Policy: \(model.policy.policy.description)")
        }
    }
}

struct PolicyPicker_Preview: PreviewProvider {
    static var previews: some View {
        PolicyPicker_Host()
    }
}

#endif

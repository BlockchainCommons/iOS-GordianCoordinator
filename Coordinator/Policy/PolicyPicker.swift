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
        Label {
            Text("Policy")
                .bold()
        } icon: {
            Image.policy
        }
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
        PolicyPicker(selectedPreset: Binding($model.policy))
    }
}

struct PolicyPicker_Preview: PreviewProvider {
    static var previews: some View {
        PolicyPicker_Host()
//            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
    }
}
#endif

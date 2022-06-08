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

class PolicyPickerSubject: ObservableObject {
    @Published var policy: PolicyPreset = .threshold2of3
}

struct PolicyPickerHost: View {
    @StateObject var subject = PolicyPickerSubject()
    
    var body: some View {
        PolicyPicker(selectedPreset: Binding($subject.policy))
    }
}

struct PolicyPicker_Preview: PreviewProvider {
    static var previews: some View {
        PolicyPickerHost()
//            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
    }
}
#endif

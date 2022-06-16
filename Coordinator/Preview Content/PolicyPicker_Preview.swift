import SwiftUI

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


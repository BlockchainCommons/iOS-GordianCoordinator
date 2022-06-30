import SwiftUI
import BCApp
import BCWally

struct NetworkPicker: View {
    @Binding var selectedNetwork: Network?
    let networks = Network.allCases
    
    var body: some View {
        VStack(alignment: .leading) {
            label
            picker
        }
    }
    
    var label: some View {
        SectionLabel("Network", icon: Image.network)
    }
    
    var picker: some View {
        SegmentPicker(selection: $selectedNetwork, segments: .constant(networks))
    }
}

#if DEBUG

class NetworkPicker_Model: ObservableObject {
    @Published var network: Network = .testnet
}

struct NetworkPicker_Host: View {
    @StateObject var model = NetworkPicker_Model()
    
    var body: some View {
        NetworkPicker(selectedNetwork: Binding($model.network))
    }
}

struct NetworkPicker_Preview: PreviewProvider {
    static var previews: some View {
        NetworkPicker_Host()
            .padding()
            .preferredColorScheme(.dark)
    }
}

#endif

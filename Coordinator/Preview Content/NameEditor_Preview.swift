import SwiftUI
import WolfLorem

class NameEditorSubject: ObservableObject {
    @Published var name: String = "Hello"
}

struct NameEditorHost: View {
    let validate: Bool
    let generatesName: Bool
    @StateObject var subject = NameEditorSubject()
    @State var isValid: Bool = true

    var body: some View {
        NameEditor($subject.name, isValid: validate ? $isValid : nil, generateName: generatesName ? generateName : nil)
    }
    
    func generateName() -> String {
        Lorem.bytewords(4)
    }
}

struct NameEditor_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            VStack {
                Text("Validates:")
                    .foregroundColor(.secondary)
                    .font(.caption)
                NameEditorHost(validate: true, generatesName: true)
            }
            VStack {
                Text("Doesn't validate:")
                    .foregroundColor(.secondary)
                    .font(.caption)
                NameEditorHost(validate: false, generatesName: true)
            }
            VStack {
                Text("Doesn't validate or generate name:")
                    .foregroundColor(.secondary)
                    .font(.caption)
                NameEditorHost(validate: false, generatesName: false)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

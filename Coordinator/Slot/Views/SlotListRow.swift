import SwiftUI

struct SlotListRow: View {
    let displayIndex: Int
    let name: String
    let status: SlotStatus
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(displayIndex)")
                .monospacedDigit()
            Text(Image.publicKey)
                .foregroundColor(status.color)
            status.icon
            VStack(alignment: .leading) {
                if name.isEmpty {
                    Text(status.description)
                        .font(.headline)
                        .foregroundColor(status.color)
                } else {
                    Text(name)
                        .font(.headline)
                    Text(status.description)
                        .font(.caption)
                        .foregroundColor(status.color)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .font(.largeTitle)
        .foregroundColor(.primary)
        .padding()
    }
}

#if DEBUG

struct SlotListRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotListRow(displayIndex: 1, name: "", status: .incomplete)
            SlotListRow(displayIndex: 2, name: "Name", status: .complete(publicKey: "Key"))
        }
        .frame(width: 400)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}

#endif

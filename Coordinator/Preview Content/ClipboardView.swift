import SwiftUI

struct ClipboardView: View {
    @EnvironmentObject var clipboard: Clipboard
    
    var body: some View {
        Text(summary)
    }
    
    var summary: String {
        if clipboard.hasImage {
            return "Image"
        } else if clipboard.hasString {
            return clipboard.string!
        } else if clipboard.value == nil {
            return "Empty"
        } else {
            return "\(String(describing: clipboard.value!))"
        }
    }
}

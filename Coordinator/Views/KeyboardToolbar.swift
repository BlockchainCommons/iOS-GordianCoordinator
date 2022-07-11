import SwiftUI
import WolfSwiftUI

struct KeyboardToolbar: ToolbarContent {
    let action: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .keyboard) {
            HStack {
                Spacer()
                DoneButton {
                    action()
                }
            }
        }
    }
}

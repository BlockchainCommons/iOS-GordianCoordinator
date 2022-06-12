import SwiftUI
import BCApp
import WolfSwiftUI

struct AppToolbar: ToolbarContent {
    let isTop: Bool
    
    init(isTop: Bool = false) {
        self.isTop = isTop
    }
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            HStack(spacing: 10) {
                UserGuideButton<AppChapter>()
                ScanButton {
                }
                .hidden(!isTop)
            }
            
            Spacer()
            
            Image.bcLogo
                .accessibility(hidden: true)
            
            Spacer()
            
            Button {

            } label: {
                Image.settings
            }
            .accessibility(label: Text("Settings"))
            .hidden(!isTop)
        }
    }
}

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

import SwiftUI

struct SectionLabel: View {
    let title: String
    let icon: Image
    
    init(_ title: String, icon: Image) {
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        Label(title, icon: icon)
            .font(Font.title2.bold())
    }
}


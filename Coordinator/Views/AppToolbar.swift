import SwiftUI
import BCApp
import Combine

struct AppToolbar: ToolbarContent {
    private static let scanVisibleSubject = CurrentValueSubject<Bool, Never>(true)
    
    static func setScanVisible(_ scanVisible: Bool) {
        scanVisibleSubject.send(scanVisible)
    }
    
    @State var scanVisible: Bool
    
    init() {
        _scanVisible = State(initialValue: Self.scanVisibleSubject.value)
    }
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            HStack(spacing: 10) {
                UserGuideButton<AppChapter>()
                AppScanButton()
                    .hidden(!scanVisible)
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
            .onReceive(Self.scanVisibleSubject) { scanVisible in
                withAnimation {
                    self.scanVisible = scanVisible
                }
            }
        }
    }
}

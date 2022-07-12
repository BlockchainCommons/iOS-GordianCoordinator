import SwiftUI
import BCApp
import Combine

private let scanVisibleSubject = CurrentValueSubject<Bool, Never>(true)

func setScanVisible(_ scanVisible: Bool) {
    scanVisibleSubject.send(scanVisible)
}

struct AppToolbar<AppViewModel: AppViewModelProtocol>: ToolbarContent {
    @ObservedObject var viewModel: AppViewModel
    
    @State var scanVisible: Bool
    
    init(viewModel: AppViewModel) {
        _viewModel = ObservedObject(initialValue: viewModel)
        _scanVisible = State(initialValue: scanVisibleSubject.value)
    }
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            HStack(spacing: 10) {
                UserGuideButton<AppChapter>()
                AppScanButton(viewModel: viewModel)
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
            .onReceive(scanVisibleSubject) { scanVisible in
                withAnimation {
                    self.scanVisible = scanVisible
                }
            }
        }
    }
}

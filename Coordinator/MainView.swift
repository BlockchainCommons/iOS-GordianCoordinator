import SwiftUI

struct MainView: View {
    @StateObject var persistence: Persistence
    @StateObject var viewModel: AppViewModel

    init() {
        let persistence = Persistence()
        self._persistence = StateObject(wrappedValue: persistence)
        self._viewModel = StateObject(wrappedValue: AppViewModel(persistence: persistence))
    }
    
    var body: some View {
        NavigationView {
            AccountsList(viewModel: viewModel)
        }
        .environmentObject(persistence)
        .toolbar {
            AppToolbar(viewModel: viewModel)
        }
    }
}

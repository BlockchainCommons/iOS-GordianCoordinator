import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = AccountsViewModel(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        AccountsList_Host()
//        AccountsList(viewModel: viewModel)
//            .symbolRenderingMode(.hierarchical)
    }
}

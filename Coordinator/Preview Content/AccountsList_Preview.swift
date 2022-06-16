import SwiftUI

struct AccountsList_Host: View {
    @StateObject var viewModel = DesignTimeAppViewModel()
    
    var body: some View {
        AccountsList(viewModel: viewModel)
    }
}

struct AccountsList_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AccountsList_Host()
        }
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
        .preferredColorScheme(.dark)
    }
}

import SwiftUI
import WolfSwiftUI

struct AccountAddress_Host: View {
    @StateObject var account = DesignTimeAccount(isComplete: true)
    
    var body: some View {
        AccountAddress(account: account)
    }
}

struct AccountAddress_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AccountAddress_Host()
        }
        .preferredColorScheme(.dark)
    }
}

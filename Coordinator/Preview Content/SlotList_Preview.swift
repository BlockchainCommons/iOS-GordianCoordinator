import SwiftUI

struct SlotList_Host: View {
    @StateObject var account: DesignTimeAccount
    
    init() {
        let account = DesignTimeAccount()
        self._account = StateObject(wrappedValue: account)
        account.slots = [
            .init(account: account, displayIndex: 1, name: "Foo", status: .incomplete),
            .init(account: account, displayIndex: 2, name: "Bar", status: .complete(publicKey: randomKey())),
            .init(account: account, displayIndex: 3, name: "", status: .incomplete),
            .init(account: account, displayIndex: 4, name: "", status: .complete(publicKey: randomKey()))
        ]
        account.updateStatus()
    }
    
    var body: some View {
        NavigationView {
            SlotList(account: account)
        }
    }
}

struct SlotList_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SlotList_Host()
        }
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
        .frame(width: 400)
        .padding()
    }
}

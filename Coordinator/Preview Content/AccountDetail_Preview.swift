import SwiftUI
import BCApp

struct AccountDetail_Host: View {
    @StateObject var account = DesignTimeAccount(model: nil, accountID: UUID(), name: "Test account", policy: .threshold(quorum: 2, slots: 3), ordinal: [0])

    var body: some View {
        AccountDetail(account: account, generateName: { LifeHashNameGenerator.generate(from: account.accountID) })
    }
}

struct AccountDetail_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AccountDetail_Host()
        }
        .padding()
        .preferredColorScheme(.dark)
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
    }
}

import SwiftUI
import BCApp

struct AccountDetail: View {
    @ObservedObject var account: Account
    @Binding var selectionID: UUID?

    var body: some View {
        if selectionID == account.accountID {
            main
        } else {
            NoAccountSelected()
        }
    }
    
    var main: some View {
        ScrollView {
            VStack(spacing: 20) {
                identity
            }
        }
        .navigationTitle("Account")
        .frame(maxWidth: 600)
        .padding()
    }
    
    var identity: some View {
        ObjectIdentityBlock(model: .constant(account))
            .frame(height: 128)
    }
}

import Foundation
import WolfOrdinal
import WolfLorem
import WolfBase

class DesignTimeAccountsViewModel: AccountsViewModelProtocol {
    @Published var accounts: [DesignTimeAccount] = []
    
    init() {
        for i in 0..<3 {
            _ = newAccount(accountID: UUID(), name: Lorem.bytewords(4), policy: .threshold(quorum: 2, slots: 3), ordinal: [i])
        }
    }
    
    func newAccount(accountID: UUID, name: String, policy: Policy, ordinal: Ordinal) -> DesignTimeAccount {
        let account = DesignTimeAccount(model: self, accountID: accountID, name: name, policy: policy, ordinal: ordinal)
        accounts = accounts.appending(account).sorted()
        return account
    }
    
    func deleteAccount(account: DesignTimeAccount) {
        var accounts = self.accounts
        accounts.removeAll {
            $0.accountID == account.accountID
        }
        self.accounts = accounts
    }
    
    func saveChanges() {
    }
    
    func orderChanged() {
        accounts = accounts.sorted()
    }
}

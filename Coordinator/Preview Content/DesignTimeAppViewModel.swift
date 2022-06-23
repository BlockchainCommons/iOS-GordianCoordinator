import Foundation
import WolfOrdinal
import WolfLorem
import WolfBase

class DesignTimeAppViewModel: AppViewModelProtocol {
    @Published var accounts: [DesignTimeAccount] = []
    
    init() {
        _ = newAccount(accountID: UUID(), name: Lorem.bytewords(4), policy: .single, ordinal: [0])
        _ = newAccount(accountID: UUID(), name: Lorem.bytewords(4), policy: .threshold(quorum: 2, slots: 3), ordinal: [1])
        _ = newAccount(accountID: UUID(), name: Lorem.bytewords(4), policy: .threshold(quorum: 3, slots: 5), ordinal: [2])
    }
    
    func newAccount(accountID: UUID, name: String, policy: Policy, ordinal: Ordinal) -> DesignTimeAccount {
        let account = DesignTimeAccount(model: self, accountID: accountID, name: name, policy: policy, ordinal: ordinal)
        accounts = accounts.appending(account).sorted()
        return account
    }
    
    func deleteAccount(_ account: DesignTimeAccount) {
        var accounts = self.accounts
        accounts.removeAll {
            $0.accountID == account.accountID
        }
        self.accounts = accounts
    }
    
    func saveChanges() {
        print("🔥 Saving changes")
    }
    
    func orderChanged() {
        accounts = accounts.sorted()
    }
}

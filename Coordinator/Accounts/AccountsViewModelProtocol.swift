import Foundation
import WolfOrdinal

protocol AccountsViewModelProtocol: ObservableObject {
    associatedtype Account: AccountProtocol
    
    var accounts: [Account] { get set }

    func newAccount(accountID: UUID, name: String, policy: Policy, ordinal: Ordinal) -> Account
    func deleteAccount(account: Account)
    func saveChanges()
}

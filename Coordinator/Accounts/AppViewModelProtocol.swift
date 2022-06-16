import Foundation
import WolfOrdinal

@MainActor
protocol AppViewModelProtocol: ObservableObject {
    associatedtype Account: AccountProtocol
    
    var accounts: [Account] { get set }

    func newAccount(accountID: UUID, name: String, policy: Policy, ordinal: Ordinal) -> Account
    func deleteAccount(_ account: Account)
    func saveChanges()
}

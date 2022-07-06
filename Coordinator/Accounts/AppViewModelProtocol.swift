import Foundation
import WolfOrdinal
import BCApp

@MainActor
protocol AppViewModelProtocol: ObservableObject {
    associatedtype Account: AccountProtocol
    
    var accounts: [Account] { get set }

    func newAccount(accountID: UUID, network: Network, name: String, policy: Policy, ordinal: Ordinal) -> Account
    func deleteAccount(_ account: Account)
    func saveChanges()
}

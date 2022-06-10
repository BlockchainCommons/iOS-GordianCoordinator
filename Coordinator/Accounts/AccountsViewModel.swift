import SwiftUI
import Combine
import CoreData
import WolfBase
import WolfLorem
import WolfOrdinal
import BCApp
import os

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountsViewModel")

protocol AccountsViewModelProtocol: ObservableObject {
    associatedtype Account: AccountProtocol
    
    var accounts: [Account] { get set }

    func newAccount(accountID: UUID, name: String, notes: String, policy: Policy, ordinal: Ordinal) -> Account
    func deleteAccount(account: Account)
    func saveChanges()
}

class DesignTimeAccountsViewModel: AccountsViewModelProtocol {
    @Published var accounts: [DesignTimeAccount] = []
    
    init() {
        for i in 0..<3 {
            addAccount(ordinal: [i])
        }
    }
    
    private func addAccount(ordinal: Ordinal) {
        let account = DesignTimeAccount(accountID: UUID(), name: Lorem.bytewords(4), notes: "", policy: .threshold(quorum: 2, slots: 3), ordinal: ordinal)
        accounts.append(account)
    }
    
    func newAccount(accountID: UUID, name: String, notes: String, policy: Policy, ordinal: Ordinal) -> DesignTimeAccount {
        DesignTimeAccount(accountID: accountID, name: name, notes: notes, policy: policy, ordinal: ordinal)
    }
    
    func deleteAccount(account: DesignTimeAccount) {
        accounts.removeAll {
            $0.accountID == account.accountID
        }
    }
    
    func saveChanges() {
    }
}

class AccountsViewModel: AccountsViewModelProtocol {
    let context: NSManagedObjectContext
    @Published var accounts: [Account] = []
    
    private var cancellable: Set<AnyCancellable> = []
    private var storage: AccountsStorage!
    
    init(context: NSManagedObjectContext) {
        self.context = context
        cancellable.first?.cancel()
        cancellable.removeAll()
        storage = AccountsStorage(context: context)
        storage.accounts.sink { accounts in
            withAnimation {
                self.accounts = accounts.sorted()
            }
        }
        .store(in: &cancellable)
    }
    
    func newAccount(accountID: UUID, name: String, notes: String, policy: Policy, ordinal: Ordinal) -> Account {
        let account = Account(context: context, accountID: accountID, policy: policy, ordinal: ordinal)
        account.name = name
        account.notes = notes
        return account
    }
    
    func deleteAccount(account: Account) {
        context.delete(account)
    }
    
    func saveChanges() {
        do {
            try context.save()
        } catch {
            logger.error("⛔️ \(error.localizedDescription)")
        }
    }
}

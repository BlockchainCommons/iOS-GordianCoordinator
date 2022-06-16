import SwiftUI
import Combine
import CoreData
import WolfBase
import WolfLorem
import WolfOrdinal
import BCApp
import os

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AppViewModel")

class AppViewModel: AppViewModelProtocol {
    let persistence: Persistence
    @Published var accounts: [Account] = []
    
    private var cancellable: Set<AnyCancellable> = []
    private var storage: AppStorage!
    
    private let context: NSManagedObjectContext
    
    init(persistence: Persistence) {
        self.persistence = persistence
        let context = persistence.context
        self.context = context
        cancellable.first?.cancel()
        cancellable.removeAll()
        storage = AppStorage(context: context)
        storage.accounts.sink { accounts in
            withAnimation {
                self.accounts = accounts.sorted()
            }
        }
        .store(in: &cancellable)
    }
    
    func newAccount(accountID: UUID, name: String, policy: Policy, ordinal: Ordinal) -> Account {
        let account = Account(context: context, accountID: accountID, policy: policy, ordinal: ordinal)
        account.name = name
        return account
    }
    
    func deleteAccount(_ account: Account) {
        context.delete(account)
    }
    
    func saveChanges() {
        guard context.hasChanges else {
            return
        }

        print("🔥 Saving changes")

        do {
            try context.save()
        } catch {
            logger.error("⛔️ \(error.localizedDescription)")
        }
    }
}

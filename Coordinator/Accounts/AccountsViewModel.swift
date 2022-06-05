import SwiftUI
import Combine
import CoreData

class AccountsViewModel: ObservableObject {
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
}

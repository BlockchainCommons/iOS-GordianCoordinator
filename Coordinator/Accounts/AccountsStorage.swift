import Foundation
import Combine
import CoreData
import os
import BCApp

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountsStorage")

class AccountsStorage: NSObject {
    var accounts = CurrentValueSubject<[Account], Never>([])
    private var frc: NSFetchedResultsController<Account>
    
    init(context: NSManagedObjectContext) {
        let fetchRequest = Account.fetchRequest()
        fetchRequest.sortDescriptors = []
        self.frc = NSFetchedResultsController<Account>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        frc.delegate = self
        do {
            logger.info("🔥 performFetch")
            try frc.performFetch()
            update(frc)
        } catch {
            logger.error("⛔️ \(error.localizedDescription)")
        }
    }
    
    func update<T>(_ controller: NSFetchedResultsController<T>) {
        guard let accounts = controller.fetchedObjects as? [Account] else {
            return
        }
        self.accounts.value = accounts
    }
}

extension AccountsStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        logger.info("🔥 controllerDidChangeContent")
        update(controller)
    }
}


import Foundation
import Combine
import CoreData
import os
import BCApp

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AppStorage")

class AppStorage: NSObject {
    var accounts = CurrentValueSubject<[Account], Never>([])
    var slots = CurrentValueSubject<[Slot], Never>([])
    
    private let accountsController: NSFetchedResultsController<Account>
    private let slotsController: NSFetchedResultsController<Slot>
    
    init(context: NSManagedObjectContext) {
        let accountsFetchRequest = Account.fetchRequest()
        accountsFetchRequest.sortDescriptors = []
        accountsController = NSFetchedResultsController<Account>(fetchRequest: accountsFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

        let slotsFetchRequest = Slot.fetchRequest()
        slotsFetchRequest.sortDescriptors = []
        slotsController = NSFetchedResultsController<Slot>(fetchRequest: slotsFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()

        accountsController.delegate = self
        slotsController.delegate = self

        do {
            logger.info("🔥 performFetch")
            try accountsController.performFetch()
            updateAccounts()
            try slotsController.performFetch()
            updateSlots()
        } catch {
            logger.error("⛔️ \(error.localizedDescription)")
        }
    }
    
    func updateAccounts() {
        guard let accounts = accountsController.fetchedObjects else {
            return
        }
        self.accounts.value = accounts
    }
    
    func updateSlots() {
        guard let slots = slotsController.fetchedObjects else {
            return
        }
        self.slots.value = slots
    }
}

extension AppStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        logger.info("🔥 controllerDidChangeContent")
        switch controller {
        case accountsController:
            updateAccounts()
        case slotsController:
            updateSlots()
        default:
            fatalError()
        }
    }
}


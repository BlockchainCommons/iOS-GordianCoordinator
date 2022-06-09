import CoreData
import os
import BCApp
import WolfOrdinal

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "PersistenceController")

struct PersistenceController {
    let container: NSPersistentCloudKitContainer

    static let shared = PersistenceController()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "CoordinatorModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Run initializeCloudKitSchema() once to update the CloudKit schema every time you change the Core Data model. Do not call this code in the production environment.
        if initializeCloudKitSchema {
            do {
                try container.initializeCloudKitSchema()
            } catch {
                logger.error("Failed to initialize CloudKit schema: \(error.localizedDescription)")
            }
        } else {
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            container.viewContext.automaticallyMergesChangesFromParent = true
        }
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        var ordinal = Ordinal()
        for _ in 0..<10 {
            _ = Account(context: viewContext, accountID: UUID(), policy: .threshold(quorum: 2, slots: 3), ordinal: ordinal)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}

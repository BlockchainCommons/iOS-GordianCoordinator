import CoreData
import os
import BCApp
import WolfOrdinal
import SwiftUI

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "PersistenceController")

class Persistence: ObservableObject {
#if DEBUG
    let isDesignTime: Bool
#endif
    let container: NSPersistentCloudKitContainer!
    
    var context: NSManagedObjectContext {
        container.viewContext
    }

#if DEBUG
    init(isDesignTime: Bool = false) {
        self.isDesignTime = isDesignTime
        
        if isDesignTime {
            container = nil
        } else {
            container = Self.setupContainer()
        }
    }
#else
    init() {
        container = Self.setupContainer()
    }
#endif

    @discardableResult
    static func setupContainer(initializeCloudKitSchema: Bool = false) -> NSPersistentCloudKitContainer {
        let container = NSPersistentCloudKitContainer(name: "CoordinatorModel")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
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
        return container
    }
    
    func saveChanges() {
        print("🔥 saveChanges")
        
        func save() {
            let context = container.viewContext
            
            guard context.hasChanges else {
                print("💧 No changes")
                return
            }
            
//            let inserted = context.insertedObjects
//            if !inserted.isEmpty {
//                print("inserted: \(inserted)")
//            }
//
//            let updated = context.updatedObjects
//            if !updated.isEmpty {
//                print("updated: \(updated)")
//            }
//
//            let deleted = context.deletedObjects
//            if !deleted.isEmpty {
//                print("deleted: \(deleted)")
//            }

            do {
                try context.save()
                print("👍🏼 saved")
            } catch {
                logger.error("⛔️ \(error.localizedDescription)")
            }
        }

#if DEBUG
        if !isDesignTime {
            save()
        }
#else
        save()
#endif
    }
}

//struct PersistenceController {
//    let container: NSPersistentCloudKitContainer
//
//    static let shared = PersistenceController()
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "CoordinatorModel")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//
//        // Run initializeCloudKitSchema() once to update the CloudKit schema every time you change the Core Data model. Do not call this code in the production environment.
//        if initializeCloudKitSchema {
//            do {
//                try container.initializeCloudKitSchema()
//            } catch {
//                logger.error("Failed to initialize CloudKit schema: \(error.localizedDescription)")
//            }
//        } else {
//            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            container.viewContext.automaticallyMergesChangesFromParent = true
//        }
//    }
//}

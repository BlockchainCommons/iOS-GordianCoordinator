import SwiftUI
import CoreData

@objc(Slot)
class Slot: NSManagedObject, SlotProtocol {
    // Don't remove this constructor even though it doesn't do anything: Core Data will crash.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(context: NSManagedObjectContext?, index: Int) {
        super.init(entity: Slot.entity(), insertInto: context)
        self.slotID = UUID()
        self.index = index
    }
    
    var index: Int {
        get {
            Int(index_)
        }
        
        set {
            index_ = Int16(newValue)
        }
    }
    
    var displayIndex: Int {
        index + 1
    }
    
    var name: String {
        get {
            name_ ?? ""
        }
        set {
            let value = newValue.isEmpty ? nil : newValue
            if name_ != value {
                name_ = value
            }
        }
    }
    
    var notes: String {
        get {
            notes_ ?? ""
        }
        
        set {
            let value = newValue.isEmpty ? nil : newValue
            if notes_ != value {
                notes_ = value
            }
        }
    }

    var slotID: UUID {
        get {
            slotID_ ?? UUID()
        }
        
        set {
            slotID_ = newValue
        }
    }
    
    var account: Account {
        get {
            account_!
        }
        
        set {
            account_ = newValue
        }
    }
    
    var descriptor: String? {
        get {
            descriptor_
        }
        
        set {
            descriptor_ = newValue
        }
    }
}

extension Slot: Comparable {
    static func ==(lhs: Slot, rhs: Slot) -> Bool {
        lhs.slotID == rhs.slotID
    }
    
    static func <(lhs: Slot, rhs: Slot) -> Bool {
        lhs.index < rhs.index
    }
}

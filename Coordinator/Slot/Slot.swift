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
        self.status = .incomplete
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
            let trimmed = newValue.trim()
            if trimmed.isEmpty {
                name_ = nil
            } else {
                name_ = trimmed
            }
        }
    }
    
    var notes: String {
        get {
            notes_ ?? ""
        }
        
        set {
            let trimmed = newValue.trim()
            if trimmed.isEmpty {
                notes_ = nil
            } else {
                notes_ = trimmed
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
    
    var status: SlotStatus {
        get {
            try! SlotStatus(encoded: status_!)
        }
        
        set {
            status_ = newValue.encoded
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

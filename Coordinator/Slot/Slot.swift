import SwiftUI
import CoreData
import BCFoundation

@objc(Slot)
class Slot: NSManagedObject, SlotProtocol {
    // Don't remove this constructor even if it doesn't do anything: Core Data will crash.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        _descriptor.instance = self
    }

    convenience init(context: NSManagedObjectContext?, index: Int) {
        self.init(entity: Slot.entity(), insertInto: context)
        
        self.slotID = UUID()
        self.name_ = ""
        self.notes_ = ""
        self.index = Int16(index)
        self.challenge = SecureRandomNumberGenerator.shared.data(count: 16)
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Slot> {
        return NSFetchRequest<Slot>(entityName: "Slot")
    }

    @NSManaged public var slotID: UUID
    @NSManaged public var name_: String
    @NSManaged public var notes_: String
    @NSManaged public var index: Int16
    @NSManaged public var account: Account
    @NSManaged public var challenge: Data

    @NSManaged public var descriptor_: String?

    var displayIndex: Int {
        Int(index + 1)
    }
    
    @Transformer(deduplicate: \Slot.name_, defaultValue: "")
    var name: String
    
    @Transformer(deduplicate: \Slot.notes_, defaultValue: "")
    var notes: String

    @Transformer(rawKeyPath: \Slot.descriptor_, toValue: { source in
        guard let source else {
            return nil
        }
        return try! OutputDescriptor.fromJSON(source)
    }, toRaw: {
        $0?.jsonString
    })
    var descriptor: OutputDescriptor?
}

extension Slot: Comparable {
    static func ==(lhs: Slot, rhs: Slot) -> Bool {
        lhs.slotID == rhs.slotID
    }
    
    static func <(lhs: Slot, rhs: Slot) -> Bool {
        lhs.index < rhs.index
    }
}

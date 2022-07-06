import Foundation
import CoreData
import WolfOrdinal
import WolfBase
import BCApp
import SwiftUI
import LifeHash

@objc(Account)
class Account: NSManagedObject, AccountProtocol {
    let modelObjectType = ModelObjectType.account
    
    // Don't remove this constructor even if it doesn't do anything: Core Data will crash.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        _name.instance = self
        _notes.instance = self
        _network.instance = self
        _ordinal.instance = self
        _policy.instance = self
        _status.instance = self
    }
    
    convenience init(context: NSManagedObjectContext?, accountID: UUID, network: Network, policy: Policy, ordinal: Ordinal, name: String? = nil, notes: String = "") {
        self.init(entity: Account.entity(), insertInto: context)

        self.accountID = accountID
        self.network = network
        self.policy = policy
        self.ordinal = ordinal
        if let name {
            self.name_ = name
        } else {
            self.name_ = LifeHashNameGenerator.generate(from: accountID)
        }
        self.notes_ = notes
        let slotsCount = policy.slots
        self.status = .incomplete(slotsRemaining: slotsCount)
        
        for index in 0..<slotsCount {
            let slot = Slot(context: context, index: index)
            addSlot(slot)
        }
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var accountID: UUID
    
    @NSManaged public var name_: String
    @NSManaged public var notes_: String
    @NSManaged public var network_: String
    @NSManaged public var ordinal_: String
    @NSManaged public var policy_: String
    @NSManaged public var status_: String

    @NSManaged public var slots_: NSSet
    
    @Transformer(deduplicate: \Account.name_, defaultValue: "")
    var name: String
    
    @Transformer(deduplicate: \Account.notes_, defaultValue: "")
    var notes: String

    @Transformer(json: \Account.ordinal_, defaultValue: [0])
    var ordinal: Ordinal
    
    @Transformer(json: \Account.policy_, defaultValue: .single)
    var policy: Policy
    
    @Transformer(json: \Account.status_, defaultValue: .incomplete(slotsRemaining: 0))
    var status: AccountStatus
    
    @Transformer(rawKeyPath: \Account.network_, defaultValue: .testnet, toValue: {
        Network(id: $0)!
    }, toRaw: {
        $0.id
    })
    var network: Network
}

// MARK: accessors for slots
extension Account {
    @objc(addSlots_Object:)
    @NSManaged public func addToSlots_(_ value: Slot)

    @objc(removeSlots_Object:)
    @NSManaged public func removeFromSlots_(_ value: Slot)

    @objc(addSlots_:)
    @NSManaged public func addToSlots_(_ values: NSSet)

    @objc(removeSlots_:)
    @NSManaged public func removeFromSlots_(_ values: NSSet)

    @nonobjc dynamic
    var slots: [Slot] {
        get {
            let s = slots_ as! Set<Slot>
            return s.sorted()
        }
    }
    
    @nonobjc dynamic
    func addSlot(_ slot: Slot) {
        addToSlots_(slot)
    }

    @nonobjc
    var instanceDetail: String? {
        policy†
    }
}

extension ModelObjectType {
    static let account = ModelObjectType(name: "Account", type: "Account", icon: Image.account.icon().eraseToAnyView())
}

extension Account: Fingerprintable {
    var fingerprintData: Data {
        accountID.fingerprintData
    }
}

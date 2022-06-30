import Foundation
import CoreData
import WolfOrdinal
import WolfBase
import BCApp
import SwiftUI
import LifeHash
import BCWally
import BCFoundation

@objc(Account)
class Account: NSManagedObject, AccountProtocol {
    let modelObjectType = ModelObjectType.account
    
    // Don't remove this constructor even though it doesn't do anything: Core Data will crash.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
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
            self.name = name
        } else {
            self.name = LifeHashNameGenerator.generate(from: accountID)
        }
        self.notes = notes
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
    @NSManaged public var name: String
    @NSManaged public var notes: String

    @NSManaged public var network_: String
    @NSManaged public var ordinal_: String
    @NSManaged public var policy_: String
    @NSManaged public var status_: String
    @NSManaged public var slots_: NSSet
    
    @Transformer(rawKeyPath: \Account.ordinal_, defaultValue: [0])
    var ordinal: Ordinal
    
    @Transformer(rawKeyPath: \Account.policy_, defaultValue: .single)
    var policy: Policy
    
    @Transformer(rawKeyPath: \Account.status_, defaultValue: .incomplete(slotsRemaining: 0))
    var status: AccountStatus
    
    @Transformer(rawKeyPath: \Account.network_, defaultValue: .testnet)
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

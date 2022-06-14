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

    // Don't remove this constructor even though it doesn't do anything: Core Data will crash.
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(context: NSManagedObjectContext?, accountID: UUID, policy: Policy, ordinal: Ordinal) {
        super.init(entity: Account.entity(), insertInto: context)
        self.accountID = accountID
        self.policy = policy
        self.ordinal = ordinal
        self.name = LifeHashNameGenerator.generate(from: accountID)
        let slots = policy.slots
        self.status = .incomplete(slotsRemaining: slots)
        
        for index in 0..<slots {
            let slot = Slot(context: context, index: index)
            addSlot(slot)
        }
    }
    
    @nonobjc
    var accountID: UUID {
        get {
            accountID_ ?? UUID()
        }
        
        set {
            accountID_ = newValue
        }
    }
    
    @nonobjc
    var name: String {
        get {
            name_ ?? ""
        }
        
        set {
            name_ = newValue.isEmpty ? nil : newValue
        }
    }
    
    @nonobjc
    var notes: String {
        get {
            notes_ ?? ""
        }
        
        set {
            notes_ = newValue.isEmpty ? nil : newValue
        }
    }
    
    @nonobjc
    var ordinal: Ordinal {
        get {
            try! Ordinal(encoded: ordinal_!)
        }
        
        set {
            ordinal_ = newValue.encoded
        }
    }

    @nonobjc
    var policy: Policy {
        get {
            guard let policy_ = policy_ else {
                return .threshold(quorum: 2, slots: 3)
            }
            return (try? Policy(encoded: policy_)) ?? .threshold(quorum: 2, slots: 3)
        }
        
        set {
            policy_ = newValue.encoded
        }
    }
    
    @nonobjc
    var status: AccountStatus {
        get {
            guard let status_ = status_ else {
                return .incomplete(slotsRemaining: 3)
            }
            return (try? AccountStatus(encoded: status_)) ?? .incomplete(slotsRemaining: 3)
        }
        
        set {
            status_ = newValue.encoded
        }
    }
    
    @nonobjc dynamic
    var slots: [Slot] {
        get {
            guard
                let s = slots_ as? Set<Slot> else {
                return []
            }
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
    
    @nonobjc
    var subtypes: [ModelSubtype] {
        let subtype = ModelSubtype(
            id: UUID().uuidString,
            icon: AccountStatusIndicator(status: status)
                .eraseToAnyView()
        )
        return [subtype]
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

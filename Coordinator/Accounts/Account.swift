import Foundation
import CoreData
import WolfOrdinal
import WolfBase
import BCApp
import SwiftUI
import LifeHash

@objc(Account)
class Account: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(context: NSManagedObjectContext, policy: Policy, ordinal: Ordinal) {
        super.init(entity: Account.entity(), insertInto: context)
        self.accountID = UUID()
        self.policy = policy
        self.ordinal = ordinal
        self.name = LifeHashNameGenerator.generate(from: accountID)
    }
    
    var policy: Policy {
        get {
            try! Policy(encoded: policy_!)
        }
        
        set {
            policy_ = newValue.encoded
        }
    }
    
    var ordinal: Ordinal {
        get {
            try! Ordinal(encoded: ordinal_!)
        }
        
        set {
            ordinal_ = newValue.encoded
        }
    }
    
    var accountID: UUID {
        get {
            accountID_ ?? UUID()
        }
        
        set {
            accountID_ = newValue
        }
    }
    
    var name: String {
        get {
            name_ ?? "untitled"
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
}

extension Account: Comparable {
    static func ==(lhs: Account, rhs: Account) -> Bool {
        lhs.accountID == rhs.accountID
    }
    
    static func <(lhs: Account, rhs: Account) -> Bool {
        guard lhs != rhs else {
            return false
        }
        if lhs.ordinal == rhs.ordinal {
            return lhs.accountID.uuidString < rhs.accountID.uuidString
        }
        return lhs.ordinal < rhs.ordinal
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

extension Account: ObjectIdentifiable {
    var modelObjectType: ModelObjectType {
        .account
    }
    
    var subtypes: [ModelSubtype] {
        []
    }
    
    var sizeLimitedQRString: (String, Bool) {
        todo()
    }
}

import SwiftUI
import BCApp
import WolfBase
import WolfOrdinal
import Combine
import WolfLorem

class DesignTimeAccount: ObservableObject, AccountProtocol {
    let modelObjectType = ModelObjectType.account
    weak var model: DesignTimeAccountsViewModel?
    let accountID: UUID
    let policy: Policy
    private(set) var slots: [DesignTimeSlot]

    var id: UUID { accountID }

    var fingerprintData: Data {
        accountID.fingerprintData
    }

    @Published var name: String
    @Published var notes: String
    @Published var ordinal: Ordinal {
        didSet {
            model?.orderChanged()
        }
    }

    init(model: DesignTimeAccountsViewModel?, accountID: UUID, name: String, notes: String, policy: Policy, ordinal: Ordinal) {
        self.model = model
        self.accountID = accountID
        self.name = name
        self.notes = notes
        self.policy = policy
        self.ordinal = ordinal
        self.slots = []
        
        for index in 0..<policy.slots {
            slots.append(DesignTimeSlot(account: self, displayIndex: index, name: "", status: .incomplete))
        }
    }
    
    convenience init() {
        self.init(model: nil, accountID: UUID(), name: Lorem.bytewords(4), notes: "", policy: .threshold(quorum: 2, slots: 3), ordinal: [0])
    }
    
    var status: AccountStatus {
        let completeSlots = slots.filter {
            $0.isComplete
        }.count
        
        if completeSlots == slots.count {
            return .complete
        } else {
            return .incomplete(slotsRemaining: slots.count - completeSlots)
        }
    }

    var instanceDetail: String? {
        policy†
    }
    
    var subtypes: [ModelSubtype] {
        let subtype = ModelSubtype(
            id: UUID().uuidString,
            icon: AccountStatusIndicator(status: status)
                .eraseToAnyView()
        )
        return [subtype]
    }
}

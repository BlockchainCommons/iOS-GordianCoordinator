import SwiftUI
import BCApp
import WolfBase
import WolfOrdinal
import Combine
import WolfLorem

class DesignTimeAccount: AccountProtocol {
    let modelObjectType = ModelObjectType.account
    weak var model: DesignTimeAppViewModel?
    let accountID: UUID
    let policy: Policy
    var slots: [DesignTimeSlot]

    var id: UUID { accountID }

    var fingerprintData: Data {
        accountID.fingerprintData
    }

    @Published var status: AccountStatus
    @Published var name: String
    @Published var notes: String
    @Published var ordinal: Ordinal {
        didSet {
            model?.orderChanged()
        }
    }

    init(model: DesignTimeAppViewModel?, accountID: UUID, name: String, notes: String = "", policy: Policy, ordinal: Ordinal) {
        self.model = model
        self.accountID = accountID
        self.name = name
        self.notes = notes
        self.policy = policy
        self.ordinal = ordinal
        self.slots = []
        let slotsCount = policy.slots
        self.status = .incomplete(slotsRemaining: slotsCount)

        for index in 0..<slotsCount {
            slots.append(DesignTimeSlot(account: self, displayIndex: index, status: .incomplete))
        }
    }
    
    convenience init() {
        self.init(model: nil, accountID: UUID(), name: Lorem.bytewords(4), policy: .threshold(quorum: 2, slots: 3), ordinal: [0])
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

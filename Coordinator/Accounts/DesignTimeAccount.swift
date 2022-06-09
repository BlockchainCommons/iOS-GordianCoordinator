import SwiftUI
import BCApp
import WolfBase

class DesignTimeAccount: ObservableObject, AccountProtocol {
    let modelObjectType = ModelObjectType.account
    let accountID = UUID()
    let policy: Policy
    let slots: [DesignTimeSlot]

    var id: UUID { accountID }

    var fingerprintData: Data {
        id.fingerprintData
    }

    @Published var name: String
    @Published var notes: String

    init(name: String, notes: String, policy: Policy) {
        self.name = name
        self.notes = notes
        self.policy = policy
        
        var slots: [DesignTimeSlot] = []
        for index in 0..<policy.slots {
            slots.append(DesignTimeSlot(displayIndex: index, name: "", status: .incomplete))
        }
        self.slots = slots
    }

    static func == (lhs: DesignTimeAccount, rhs: DesignTimeAccount) -> Bool {
        lhs.id == rhs.id
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

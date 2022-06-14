import Foundation
import BCApp
import WolfBase
import LifeHash

class AccountSetupModel: ObservableObject {
    let accountID: UUID
    @Published var policy: Policy = .threshold(quorum: 2, slots: 3)
    @Published var name: String
    @Published var notes: String = ""
    
    init() {
        let accountID = UUID()
        self.accountID = accountID
        self.name = LifeHashNameGenerator.generate(from: accountID)
    }
}

extension AccountSetupModel: Fingerprintable {
    var fingerprintData: Data {
        accountID.fingerprintData
    }
}

extension AccountSetupModel: Equatable {
    static func == (lhs: AccountSetupModel, rhs: AccountSetupModel) -> Bool {
        lhs.accountID == rhs.accountID
    }
}

extension AccountSetupModel: ObjectIdentifiable {
    var modelObjectType: ModelObjectType {
        .account
    }
    
    var instanceDetail: String? {
        policy.description
    }
}

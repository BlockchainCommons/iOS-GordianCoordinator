import Foundation
import BCApp
import WolfOrdinal
import BCFoundation
import BCWally

@MainActor
protocol AccountProtocol: ObservableObject, Identifiable, ObjectIdentifiable, Comparable {
    associatedtype ID
    associatedtype Slot: SlotProtocol

    var id: ID { get }
    var accountID: UUID { get }
    var ordinal: Ordinal { get set }
    var name: String { get set }
    var notes: String { get set }
    var slots: [Slot] { get }
    var status: AccountStatus { get set }
    var policy: Policy { get }
    var network: Network { get }
    
    func updateStatus()
}

extension AccountProtocol {
    func updateStatus() {
        let completeSlots = slots.filter { $0.status == .complete }.count
        if completeSlots == slots.count {
            self.status = .complete
        } else {
            self.status = .incomplete(slotsRemaining: slots.count - completeSlots)
        }
    }
    
    var isComplete: Bool {
        if case .complete = self.status {
            return true
        } else {
            return false
        }
    }
}

extension AccountProtocol {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.accountID == rhs.accountID
    }
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        guard lhs != rhs else {
            return false
        }
        if lhs.ordinal == rhs.ordinal {
            return lhs.accountID.uuidString < rhs.accountID.uuidString
        }
        return lhs.ordinal < rhs.ordinal
    }
}

extension AccountProtocol {
    var subtypes: [ModelSubtype] {
        let networkSubtype = ModelSubtype(id: network.id, icon: network.icon)
        let accountStatusSubtype = ModelSubtype(
            id: UUID().uuidString,
            icon: AccountStatusIndicator(status: status)
                .eraseToAnyView()
        )
        return [networkSubtype, accountStatusSubtype]
    }
}

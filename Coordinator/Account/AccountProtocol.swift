import Foundation
import BCApp
import WolfOrdinal

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
    
    func updateStatus()
}

extension AccountProtocol {
    func updateStatus() {
        let completeSlots = slots.filter { $0.isComplete }.count
        if completeSlots == slots.count {
            self.status = .complete
        } else {
            self.status = .incomplete(slotsRemaining: slots.count - completeSlots)
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

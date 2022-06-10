import Foundation
import BCApp
import WolfOrdinal

protocol AccountProtocol: ObservableObject, Identifiable, ObjectIdentifiable {
    associatedtype ID
    associatedtype Slot: SlotProtocol

    var id: ID { get }
    var accountID: UUID { get }
    var ordinal: Ordinal { get set }
    var name: String { get set }
    var notes: String { get set }
    var slots: [Slot] { get }
    var status: AccountStatus { get }
    var policy: Policy { get }
}

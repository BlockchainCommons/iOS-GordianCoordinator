import Foundation

protocol SlotProtocol: ObservableObject, Identifiable {
    associatedtype ID
    associatedtype Account: AccountProtocol
    
    var id: ID { get }
    var slotID: UUID { get }
    var account: Account { get }
    var displayIndex: Int { get }
    var name: String { get }
    var status: SlotStatus { get }
    var isComplete: Bool { get }
}

extension SlotProtocol {
    var isComplete: Bool {
        status.isComplete
    }
}

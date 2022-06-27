import Foundation

@MainActor
protocol SlotProtocol: ObservableObject, Identifiable {
    associatedtype ID
    associatedtype Account: AccountProtocol
    
    var id: ID { get }
    var slotID: UUID { get }
    var account: Account { get }
    var displayIndex: Int { get }
    var name: String { get set }
    var notes: String { get set }
    var status: SlotStatus { get set }
    var isComplete: Bool { get }
}

extension SlotProtocol {
    var isComplete: Bool {
        status.isComplete
    }
    
    var key: String? {
        if case let .complete(key) = status {
            return key
        }
        return nil
    }
}

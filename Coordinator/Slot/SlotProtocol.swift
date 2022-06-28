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
    var descriptor: String? { get set }
    var status: SlotStatus { get }
}

extension SlotProtocol {
    var status: SlotStatus {
        descriptor == nil ? .incomplete : .complete
    }
}

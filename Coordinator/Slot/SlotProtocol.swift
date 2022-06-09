import Foundation

protocol SlotProtocol: Identifiable {
    associatedtype ID
    
    var id: ID { get }
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

import Foundation
import BCFoundation

@MainActor
protocol SlotProtocol: ObservableObject, Identifiable {
    associatedtype ID
    associatedtype Account: AccountProtocol
    
    var id: ID { get }
    var slotID: CID { get }
    var account: Account { get }
    var displayIndex: Int { get }
    var name: String { get set }
    var notes: String { get set }
    var descriptor: OutputDescriptor? { get set }
    var status: SlotStatus { get }
    var challenge: Data { get }
    var outputDescriptorRequest: TransactionRequest { get }
}

extension SlotProtocol {
    var status: SlotStatus {
        descriptor == nil ? .incomplete : .complete
    }

    var outputDescriptorRequest: TransactionRequest {
        TransactionRequest(
            id: slotID,
            body: OutputDescriptorRequestBody(name: name, useInfo: account.useInfo, challenge: challenge),
            note: notes
        )
    }
}

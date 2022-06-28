import Foundation
import Combine

class DesignTimeSlot: ObservableObject, SlotProtocol {
    let account: DesignTimeAccount
    let displayIndex: Int
    let slotID: UUID

    @Published var name: String
    @Published var notes: String
    @Published var descriptor: String?
    
    init(account: DesignTimeAccount, displayIndex: Int, name: String = "", notes: String = "", descriptor: String?) {
        self.slotID = UUID()
        self.account = account
        self.displayIndex = displayIndex
        self.name = name
        self.notes = notes
        self.descriptor = descriptor
    }
}

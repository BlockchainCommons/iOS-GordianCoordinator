import Foundation
import Combine

class DesignTimeSlot: ObservableObject, SlotProtocol {
    let account: DesignTimeAccount
    let displayIndex: Int
    let slotID: UUID

    @Published var name: String
    @Published var status: SlotStatus
    
    init(account: DesignTimeAccount, displayIndex: Int, name: String, status: SlotStatus) {
        self.slotID = UUID()
        self.account = account
        self.displayIndex = displayIndex
        self.name = name
        self.status = status
    }
}

import Foundation

class DesignTimeSlot: ObservableObject, SlotProtocol {
    let displayIndex: Int
    @Published var name: String
    @Published var status: SlotStatus
    
    init(displayIndex: Int, name: String, status: SlotStatus) {
        self.displayIndex = displayIndex
        self.name = name
        self.status = status
    }
}

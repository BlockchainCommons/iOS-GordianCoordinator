#if DEBUG

import Foundation
import Combine
import BCFoundation

class DesignTimeSlot: ObservableObject, SlotProtocol {
    let account: DesignTimeAccount
    let displayIndex: Int
    let slotID: UUID
    let challenge: Data

    @Published var name: String
    @Published var notes: String
    @Published var descriptor: OutputDescriptor?
    
    init(account: DesignTimeAccount, displayIndex: Int, name: String = "", notes: String = "", descriptor: OutputDescriptor?) {
        self.slotID = UUID()
        self.account = account
        self.displayIndex = displayIndex
        self.name = name
        self.notes = notes
        self.descriptor = descriptor
        self.challenge = SecureRandomNumberGenerator.shared.data(count: 16)
    }
}

#endif

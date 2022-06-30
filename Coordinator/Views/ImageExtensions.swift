import SwiftUI

extension Image {
    static let slot = Image(systemName: "rectangle.and.pencil.and.ellipsis")
    
    static let incompleteSlotNumbered = Image(systemName: "square.dashed")
    static let incompleteSlot = Image(systemName: "questionmark.square.dashed")
    static let completeSlot = Image(systemName: "checkmark.square.fill")
    static let network = Image(systemName: "network")
    
    static let disclosureIndicator = Image(systemName: "chevron.right")
        .flipsForRightToLeftLayoutDirection(true)
        .foregroundColor(.secondary)
        .font(.caption)
        .eraseToAnyView()
}

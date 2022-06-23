import Foundation

enum SlotDataType: String, Hashable, CustomStringConvertible {
    case key
    case descriptor
    
    var description: String {
        self.rawValue
    }
}

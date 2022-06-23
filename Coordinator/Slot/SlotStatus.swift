import Foundation
import WolfBase
import SwiftUI

enum SlotStatus {
    case incomplete
    case complete(String)
}

extension SlotStatus: Codable {
    private enum CodingKeys: CodingKey {
        case type
        case publicKey
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .incomplete:
            try container.encode("incomplete", forKey: .type)
        case .complete(let value):
            try container.encode("complete", forKey: .type)
            try container.encode(value, forKey: .publicKey)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "incomplete":
            self = .incomplete
        case "complete":
            let publicKey = try container.decode(String.self, forKey: .publicKey)
            self = .complete(publicKey)
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown SlotStatus: \(type)"))
        }
    }
    
    var encoded: String {
        try! JSONEncoder().encode(self).utf8!
    }
    
    init(encoded: String) throws {
        self = try JSONDecoder().decode(SlotStatus.self, from: encoded.utf8Data)
    }
    
    var isComplete: Bool {
        if case .complete = self {
            return true
        }
        return false
    }
}

extension SlotStatus {
    @ViewBuilder
    var icon: some View {
        image
            .foregroundColor(color)
    }
    
    @ViewBuilder
    var image: some View {
        switch self {
        case .complete:
            Image.completeSlot
        case .incomplete:
            Image.incompleteSlot
        }
    }
    
    var color: Color {
        switch self {
        case .complete:
            return .green
        case .incomplete:
            return .yellowLightSafe
        }
    }
}

extension SlotStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .complete:
            return "Complete"
        case .incomplete:
            return "Incomplete"
        }
    }
}

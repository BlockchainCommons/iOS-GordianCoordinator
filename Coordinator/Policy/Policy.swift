import Foundation
import WolfBase

enum Policy {
    case threshold(quorum: Int, slots: Int)
}

extension Policy {
    var slots: Int {
        switch self {
        case .threshold(quorum: _, slots: let slots):
            return slots
        }
    }
}

extension Policy: Codable {
    private enum CodingKeys: CodingKey {
        case type
        case quorum
        case slots
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .threshold(quorum: let quorum, slots: let slots):
            try container.encode("threshold", forKey: .type)
            try container.encode(quorum, forKey: .quorum)
            try container.encode(slots, forKey: .slots)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "threshold":
            let quorum = try container.decode(Int.self, forKey: .quorum)
            let slots = try container.decode(Int.self, forKey: .slots)
            self = .threshold(quorum: quorum, slots: slots)
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown Policy type: \(type)"))
        }
    }
    
    var encoded: String {
        try! JSONEncoder().encode(self).utf8!
    }
    
    init(encoded: String) throws {
        self = try JSONDecoder().decode(Policy.self, from: encoded.utf8Data)
    }
}

extension Policy: CustomStringConvertible {
    var description: String {
        switch self {
        case .threshold(quorum: let quorum, slots: let slots):
            return "\(quorum) of \(slots)"
        }
    }
}

import Foundation
import WolfBase
import CoreData

enum Policy {
    case threshold(quorum: Int, signers: Int)
}

extension Policy: Codable {
    private enum CodingKeys: CodingKey {
        case type
        case quorum
        case signers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .threshold(quorum: let quorum, signers: let signers):
            try container.encode("threshold", forKey: .type)
            try container.encode(quorum, forKey: .quorum)
            try container.encode(signers, forKey: .signers)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "threshold":
            let quorum = try container.decode(Int.self, forKey: .quorum)
            let signers = try container.decode(Int.self, forKey: .signers)
            self = .threshold(quorum: quorum, signers: signers)
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
        case .threshold(quorum: let quorum, signers: let signers):
            return "\(quorum) of \(signers)"
        }
    }
}

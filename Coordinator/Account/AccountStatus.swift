import Foundation
import WolfBase

enum AccountStatus: Equatable {
    case incomplete(slotsRemaining: Int)
    case complete
}

extension AccountStatus: Codable {
    private enum CodingKeys: CodingKey {
        case type
        case slotsRemaining
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .incomplete(slotsRemaining: let slotsRemaining):
            try container.encode("incomplete", forKey: .type)
            try container.encode(slotsRemaining, forKey: .slotsRemaining)
        case .complete:
            try container.encode("complete", forKey: .type)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "incomplete":
            let slotsRemaining = try container.decode(Int.self, forKey: .slotsRemaining)
            self = .incomplete(slotsRemaining: slotsRemaining)
        case "complete":
            self = .complete
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown AccountStatus: \(type)"))
        }
    }
}

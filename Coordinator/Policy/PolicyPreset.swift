import SwiftUI
import BCApp
import SwiftUI

enum PolicyPreset: Int, CaseIterable {
    case threshold1of1
    case threshold2of3
    case threshold3of5
    case threshold4of9
}

extension PolicyPreset: Identifiable {
    var id: Int {
        rawValue
    }
}

extension PolicyPreset {
    var policy: Policy {
        switch self {
        case .threshold1of1:
            return .threshold(quorum: 1, signers: 1)
        case .threshold2of3:
            return .threshold(quorum: 2, signers: 3)
        case .threshold3of5:
            return .threshold(quorum: 3, signers: 5)
        case .threshold4of9:
            return .threshold(quorum: 4, signers: 9)
        }
    }
}

extension PolicyPreset: Segment {
    var label: AnyView {
        Text(policy.description)
            .eraseToAnyView()
    }
}

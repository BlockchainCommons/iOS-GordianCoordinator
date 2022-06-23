import SwiftUI
import BCApp
import SwiftUI

enum PolicyPreset: Int, CaseIterable {
    case single
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
        case .single:
            return .single
        case .threshold2of3:
            return .threshold(quorum: 2, slots: 3)
        case .threshold3of5:
            return .threshold(quorum: 3, slots: 5)
        case .threshold4of9:
            return .threshold(quorum: 4, slots: 9)
        }
    }
}

extension PolicyPreset: Segment {
    var label: AnyView {
        Text(policy.description)
            .eraseToAnyView()
    }
}

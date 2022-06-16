import Foundation
import UIKit
import SwiftUI
import Combine


//class Clipboard: ObservableObject {
//    let isDesignTime: Bool
//
//    init(isDesignTime: Bool = false) {
//        self.isDesignTime = isDesignTime
//    }
//
//    var hasString: Bool {
//        UIPasteboard.general.hasStrings
//    }
//
//    var hasImage: Bool {
//        UIPasteboard.general.hasImages
//    }
//
//    var string: String? {
//        get {
//            UIPasteboard.general.string
//        }
//
//        set {
//            UIPasteboard.general.string = newValue
//        }
//    }
//
//    var image: UIImage? {
//        get {
//            UIPasteboard.general.image
//        }
//
//        set {
//            UIPasteboard.general.image = newValue
//        }
//    }
//}


class Clipboard: ObservableObject {
#if DEBUG
    @Published var value: Any?
    let isDesignTime: Bool

    init(isDesignTime: Bool = false) {
        self.isDesignTime = isDesignTime
    }
#else
    init() {
    }
#endif

    var hasString: Bool {
#if DEBUG
        if isDesignTime {
            return value is String
        } else {
            return UIPasteboard.general.hasStrings
        }
#else
        UIPasteboard.general.hasStrings
#endif
    }

    var hasImage: Bool {
#if DEBUG
        if isDesignTime {
            return value is UIImage
        } else {
            return UIPasteboard.general.hasImages
        }
#else
        UIPasteboard.general.hasImages
#endif
    }

    var string: String? {
        get {
#if DEBUG
            if isDesignTime {
                return value as? String
            } else {
                return UIPasteboard.general.string
            }
#else
            UIPasteboard.general.string
#endif
        }

        set {
#if DEBUG
            if isDesignTime {
                value = newValue
            }
#endif
            UIPasteboard.general.string = newValue
        }
    }

    var image: UIImage? {
        get {
#if DEBUG
            if isDesignTime {
                return value as? UIImage
            } else {
                return UIPasteboard.general.image
            }
#else
            UIPasteboard.general.image
#endif
        }

        set {
#if DEBUG
            if isDesignTime {
                value = newValue
            }
#endif
            UIPasteboard.general.image = newValue
        }
    }
}

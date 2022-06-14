import Foundation
import UIKit
import SwiftUI
import Combine

fileprivate protocol ClipboardProtocol: AnyObject {
    var hasString: Bool { get }
    var hasImage: Bool { get }
    var string: String? { get set }
    var image: UIImage? { get set }
}

fileprivate class SystemClipboard: ClipboardProtocol {
    init() {
    }

    var hasString: Bool {
        return UIPasteboard.general.hasStrings
    }
    
    var string: String? {
        get {
            return UIPasteboard.general.string
        }
        
        set {
            UIPasteboard.general.string = newValue
        }
    }
    
    var hasImage: Bool {
        return UIPasteboard.general.hasImages
    }
    
    var image: UIImage? {
        get {
            return UIPasteboard.general.image
        }
        
        set {
            UIPasteboard.general.image = newValue
        }
    }
}

class Clipboard: ObservableObject, ClipboardProtocol {
    private let _clipboard: ClipboardProtocol
    
    init(isDesignTime: Bool = false) {
        if isDesignTime {
            _clipboard = DesignTimeClipboard()
        } else {
            _clipboard = SystemClipboard()
        }
    }

    var hasString: Bool {
        _clipboard.hasString
    }
    
    var hasImage: Bool {
        _clipboard.hasImage
    }
    
    var image: UIImage? {
        get { _clipboard.image }
        set { _clipboard.image = newValue }
    }
    
    var string: String? {
        get { _clipboard.string }
        set { _clipboard.string = newValue }
    }
}

#if DEBUG

fileprivate class DesignTimeClipboard: ClipboardProtocol {
    private var value: Any?

    init() {
        
    }

    var hasString: Bool {
        value is String
    }
    
    var string: String? {
        get { value as? String }
        set { value = newValue }
    }
    
    var hasImage: Bool {
        value is UIImage
    }
    
    var image: UIImage? {
        get { value as? UIImage }
        set { value = newValue }
    }
}

#endif

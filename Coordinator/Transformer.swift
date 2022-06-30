import SwiftUI
import WolfBase

@propertyWrapper public struct Transformer<Encloser, Raw, Value>
where Encloser: AnyObject, Raw: Equatable, Value: Equatable
{
    private let box: Box
    private let rawKeyPath: ReferenceWritableKeyPath<Encloser, Raw>
    private let defaultValue: Value?
    private let toValue: (Raw) -> Value
    private let toRaw: (Value) -> Raw

    public init(rawKeyPath: ReferenceWritableKeyPath<Encloser, Raw>, defaultValue: Value? = nil, toValue: @escaping (Raw) -> Value, toRaw: @escaping (Value) -> Raw) {
        self.box = Box()
        self.rawKeyPath = rawKeyPath
        self.defaultValue = defaultValue
        self.toValue = toValue
        self.toRaw = toRaw
    }
    
    public static subscript(
        _enclosingInstance instance: Encloser,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Encloser, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Encloser, Self>
    ) -> Value {
        get {
            let storage = instance[keyPath: storageKeyPath]
            return storage.getValue(instance: instance)
        }
        
        set {
            let storage = instance[keyPath: storageKeyPath]
            storage.setValue(instance: instance, newValue: newValue)
        }
    }
    
    private func getValue(instance: Encloser) -> Value {
        let raw = instance[keyPath: rawKeyPath]
        if box.raw == raw {
            if let value = box.value {
                return value
            }
        }
        let value = toValue(raw)
        box.value = value
        box.raw = raw
        return value
    }
    
    private func setValue(instance: Encloser, newValue: Value) {
        let raw = instance[keyPath: rawKeyPath]
        let newRaw = toRaw(newValue)
        if newRaw != raw {
            box.raw = newRaw
            box.value = newValue
            instance[keyPath: rawKeyPath] = newRaw
        }
    }
    
    /// To use the projected binding, the `instance` property must previously have been set.
    /// If it is not set, then writing the binding `wrappedValue` will do nothing and reading
    /// it will return the default value.
    public var projectedValue: Binding<Value> {
        Binding {
            guard let instance else {
                guard let defaultValue else {
                    fatalError()
                }
                return defaultValue
            }
            return getValue(instance: instance)
        } set: { newValue in
            guard let instance else {
                return
            }
            setValue(instance: instance, newValue: newValue)
        }
    }
    
    @available(*, unavailable, message: "This property wrapper can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }
    
    public var instance: Encloser? {
        get { box.instance }
        set { box.instance = newValue }
    }

    private class Box {
        weak var instance: Encloser?
        var raw: Raw?
        var value: Value?
        
        init() { }
    }
}

public extension Transformer
where Value: Codable, Raw == String
{
    init(rawKeyPath: ReferenceWritableKeyPath<Encloser, Raw>, defaultValue: Value) {
        self.init(rawKeyPath: rawKeyPath, defaultValue: defaultValue, toValue: {
            try! Value.fromJSON($0)
        }, toRaw: {
            $0.jsonString
        })
    }
}

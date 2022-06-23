import Foundation

struct Memoized<T> {
    private let load: () -> T
    private let save: (T) -> Void
    private let box: Box<T>

    init(load: @escaping () -> T, save: @escaping (T) -> Void) {
        self.load = load
        self.save = save
        self.box = Box()
    }
    
    var value: T {
        get {
            if box.value == nil {
                box.value = load()
            }
            return box.value!
        }
        
        set {
            box.value = newValue
            save(newValue)
        }
    }
    
    func reset() {
        box.value = nil
    }
    
    class Box<T> {
        var value: T?
    }
}

import XCTest
@testable import Coordinator

class TransformerTests: XCTestCase {
    class TransformerTest {
        var value_: String?
        
        @Transformer(rawKeyPath: \TransformerTest.value_, defaultValue: 0, toValue: stringToInt, toRaw: intToString)
        var value: Int

        init() {
            /// This is necessary to use the `projectedValue` binding of the property wrapper.
            _value.instance = self
        }

        static func stringToInt(_ string: String?) -> Int {
            guard
                let string,
                let result = Int(string)
            else {
                return 0
            }
            return result
        }
        
        static func intToString(_ int: Int) -> String {
            String(int)
        }
    }

    func testTransformer() {
        let t = TransformerTest()
        XCTAssertEqual(t.value, 0) // Long path
        XCTAssertEqual(t.value, 0) // Short path
        
        /// Mutate underlying raw value
        t.value_ = "42"
        XCTAssertEqual(t.value, 42)
        
        /// Get the binding. Accessing the binding value will only work if the `instance`
        /// property on the property wrapper has been properly set.
        let binding = t.$value
        /// Make sure the binding returns the proper value
        XCTAssertEqual(binding.wrappedValue, 42)
        
        /// Mutate the underlying value via the binding
        binding.wrappedValue = 88
        XCTAssertEqual(binding.wrappedValue, 88)
        
        /// The wrapped value itself also reflects the mutation
        XCTAssertEqual(t.value, 88)
        
        /// Mutate the underlying raw value
        t.value_ = "32"
        XCTAssertEqual(binding.wrappedValue, 32)
    }
}

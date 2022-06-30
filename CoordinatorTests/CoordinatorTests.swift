import XCTest
import BCFoundation
import Esplora
@testable import Coordinator

// https://en.bitcoin.it/wiki/Multi-signature#Creating_a_multi-signature_address_with_Bitcoin-Qt
// https://gist.github.com/gavinandresen/3966071

class CoordinatorTests: XCTestCase {

    func testExample() throws {
        let aliceSource = "wpkh([55016b2f/84h/1h/0h]tpubDC8LiEDg3kCFJgZHhBSs6gY8WtpR1K3Y9rP3beDnR14tM5waXvgjYveW1Dmi6kr2LVdj8nPCu5myATRydoRFN2hGSwZ518rRg7KJirdAWmg/<0;1>/*)#w44vzfr8"
        let aliceDesc = try OutputDescriptor(aliceSource)
        print(aliceDesc)
        let indexRange: Range<UInt32> = 0..<20
        let addresses = aliceDesc.addresses(useInfo: UseInfo(network: .testnet), chain: .external, indexes: indexRange)
        for index in indexRange {
            print("\(index): \(addresses[index]!)")
        }
    }
}

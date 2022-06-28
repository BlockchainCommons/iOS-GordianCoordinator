import Foundation
import BCFoundation

func randomKey() -> String {
    try! HDKey(seed: Seed()).base58PublicKey!
}

func randomDescriptor() -> String {
    let masterKey = try! HDKey(seed: Seed())
    let bundle = OutputDescriptorBundle(masterKey: masterKey, network: .mainnet, account: 0)!
    return bundle.descriptors.randomElement()!.source
}

func isValidKey(_ key: String?) -> Bool {
    guard
        let key = key,
        let _ = try? HDKey(base58: key)
    else {
        return false
    }
    return true
}

func isValidDescriptor(_ source: String?) -> Bool {
    guard
        let source = source,
        let _ = try? OutputDescriptor(source)
    else {
        return false
    }
    return true
}

import Foundation
import BCFoundation

func randomKey() -> String {
    try! HDKey(seed: Seed()).base58PublicKey!
}

func randomDescriptor() -> String {
    let hdKey = try! HDKey(seed: Seed())
    return [
        "wpkh(\(hdKey.ecPublicKey.hex))",
        "wpkh(\(hdKey.ecPublicKey.uncompressed.hex))",
        "wpkh(\(hdKey.ecPrivateKey!.wif))",
        "wpkh(\(hdKey.base58PrivateKey!))",
        "wpkh(\(hdKey.base58PublicKey!))"
    ].randomElement()!
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

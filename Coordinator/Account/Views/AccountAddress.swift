//import SwiftUI
//import BCApp
//import BCFoundation
//
//struct AccountAddress<Account: AccountProtocol>: View {
//    @ObservedObject var account: Account
//    @EnvironmentObject var clipboard: Clipboard
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            SectionLabel("Account Address", icon: Image.address)
//            HStack {
//                if let address {
//                    addressHolder(address: address)
//                    Spacer()
//                    copyButton()
//                } else {
//                    Text("The Account Address will appear here when the account is complete.")
//                        .font(.caption)
//                    Spacer()
//                }
//            }
//        }
//    }
//    
//    private func addressHolder(address: Bitcoin.Address) -> some View {
//        Text(address.string)
//            .font(Font.caption.monospaced())
//            .lineLimit(3)
//            .formSectionStyle(isVisible: true)
//    }
//    
//    private func copyButton() -> some View {
//        Button {
//            guard let address = self.address?.string else {
//                return
//            }
//            clipboard.string = address
//        } label: {
//            Image.copy
//        }
//    }
//    
//    private var address: Bitcoin.Address? {
//        guard
//            let descriptor,
//            let scriptPubKey = descriptor.scriptPubKey()
//        else {
//            return nil
//        }
//        return Bitcoin.Address(scriptPubKey: scriptPubKey, network: .testnet)
//    }
//    
//    private var descriptor: OutputDescriptor? {
//        guard let source else {
//            return nil
//        }
//        return try? OutputDescriptor(source)
//    }
//    
//    private var source: String? {
//        switch account.policy {
//        case .single:
//            return singleSource
//        case .threshold:
//            return thresholdSource
//        }
//    }
//    
//    private var singleSource: String? {
//        let slot = account.slots.first!
//        switch slot.status {
//        case .incomplete:
//            return nil
//        case .complete(let value):
//            if isValidKey(value) {
//                return "wpkh(\(value))"
//            } else if isValidDescriptor(value) {
//                return value
//            } else {
//                return nil
//            }
//        }
//    }
//    
//    private var thresholdSource: String? {
//        guard let keys else {
//            return nil
//        }
//        let list = keys.joined(separator: ",")
//        return "sortedmulti(\(quorum),\(list))"
//    }
//    
//    private var quorum: Int {
//        switch account.policy {
//        case .single:
//            return 1
//        case .threshold(quorum: let quorum, slots: _):
//            return quorum
//        }
//    }
//    
//    private var keys: [String]? {
//        guard account.isComplete else {
//            return nil
//        }
//        return account.slots.map {
//            switch $0.status {
//            case .incomplete:
//                fatalError()
//            case .complete(let value):
//                return try! HDKey(base58: value).ecPublicKey.hex
//            }
//        }
//    }
//}

//import SwiftUI
//import BitcoinDevKit
//import BCFoundation
//import BCApp
//import WolfBase
//
//extension String {
//    init?(_ i: Int?) {
//        guard let i = i else {
//            return nil
//        }
//        self.init(i)
//    }
//}
//
//class WalletSweeper: ObservableObject {
//    enum SyncState {
//        case needsSync
//        case syncing
//        case synced(balance: Satoshi)
//        case error(Error)
//    }
//
//    init() {
//        syncToDescriptorSource()
//        syncToAddressGap()
//    }
//
//    @Published var descriptorValidation: Error? = nil
//    @Published var addressGap: Int? = 0
//    @Published var addressGapValidation: Error? = nil
//    @Published var isSyncing: Bool = false
//    @Published var syncState: SyncState = .needsSync {
//        didSet {
//            if case .syncing = syncState {
//                isSyncing = true
//            }
//            isSyncing = false
//        }
//    }
//    
//    /// `desc1` has a balance on it.
//    static let desc1 = "wpkh(tprv8ZgxMBicQKsPeSitUfdxhsVaf4BXAASVAbHypn2jnPcjmQZvqZYkeqx7EHQTWvdubTSDa5ben7zHC7sUsx4d8tbTvWdUtHzR8uhHg2CW7MT/*)"
//
//    static let desc2 = "wpkh(03e220e776d811c44075a4a260734445c8967865f5357ba98ead3bc6a6552c36f2)"
//    static let desc3 = "wpkh(tprv8gzC1wn3dmCrBiqDFrqhw9XXgy5t4mzeL5SdWayHBHz1GmWbRKoqDBSwDLfunPAWxMqZ9bdGsdpTiYUfYiWypv4Wfj9g7AYX5K3H9gRYNCA)"
//    
//    @Published var wallet: Wallet!
//    @Published var descriptorSource: String = WalletSweeper.desc1 {
//        didSet {
//            syncToDescriptorSource()
//        }
//    }
//
//    @Published var addressGapText: String = "20" {
//        didSet {
//            syncToAddressGap()
//        }
//    }
//    
//    @Published var recipientAddressString: String = "" {
//        didSet {
//            syncToRecipientAddress()
//        }
//    }
//    @Published var recipientAddressValidation: Error?
//    
//    @Published var psbt: String = ""
//
//    var hasValidDescriptor: Bool {
//        wallet != nil
//    }
//    
//    var hasValidAddressGap: Bool {
//        addressGap != nil
//    }
//    
//    var transactionCount: Int? {
//        guard isSynced else {
//            return nil
//        }
//        
//        let transactions = try! wallet.getTransactions()
//        return transactions.count
//    }
//    
//    var transactionCountString: String {
//        return String(transactionCount) ?? ""
//    }
//    
//    var balance: Satoshi {
//        if case let .synced(balance) = syncState {
//            return balance
//        }
//        return 0
//    }
//    
//    var balanceString: String {
//        balance.btcFormat
//    }
//    
//    var canStartSync: Bool {
//        guard !isSyncing && hasValidDescriptor && hasValidAddressGap else {
//            return false
//        }
//        return true
//    }
//    
//    var isSynced: Bool {
//        if case .synced = syncState {
//            return true
//        }
//        return false
//    }
//    
//    private func setSyncState(_ state: SyncState) async {
//        await MainActor.run {
//            syncState = state
//        }
//    }
//    
//    func syncToDescriptorSource() {
//        do {
//            wallet = try Wallet(descriptor: descriptorSource, changeDescriptor: nil, network: Network.testnet, databaseConfig: .memory)
//            syncState = .needsSync
//            descriptorValidation = nil
//            recipientAddressString = wallet.getNewAddress()
//        } catch {
//            wallet = nil
//            descriptorValidation = GeneralError("Invalid descriptor.")
//        }
//        syncState = .needsSync
//    }
//
//    func updateBalance() async {
//        guard canStartSync else {
//            return
//        }
//        
//        await setSyncState(.syncing)
//        
//        do {
//            let esplora = EsploraConfig(baseUrl: "https://blockstream.info/testnet/api/", proxy: nil, concurrency: nil, stopGap: UInt64(addressGap!), timeout: nil)
//            let config = BlockchainConfig.esplora(config: esplora)
//            let blockchain = try! Blockchain(config: config)
//            try await wallet.sync(blockchain: blockchain, progress: nil)
//            let balance = try wallet.getBalance()
//            await setSyncState(.synced(balance: balance))
//            await MainActor.run {
//                syncPSBT()
//            }
//        } catch {
//            await setSyncState(.error(error))
//        }
//    }
//    
//    func syncToAddressGap() {
//        guard
//            let a = Int(addressGapText.trim()),
//            (0..<10_000).contains(a)
//        else {
//            withAnimation {
//                addressGap = nil
//                addressGapValidation = GeneralError("Invalid address gap.")
//            }
//            return
//        }
//        withAnimation {
//            addressGap = a
//            addressGapValidation = nil
//        }
//        syncState = .needsSync
//    }
//    
//    func syncToRecipientAddress() {
//        if Bitcoin.Address(string: recipientAddressString) == nil {
//            recipientAddressValidation = GeneralError("Invalid recipient address.")
//        } else {
//            recipientAddressValidation = nil
//        }
//        syncPSBT()
//    }
//    
//    var hasRecipientAddress: Bool {
//        recipientAddressValidation == nil
//    }
//    
//    func syncPSBT() {
//        guard isSynced,
//              hasRecipientAddress
//        else {
//            psbt = ""
//            return
//        }
//        let psbtBase64 = try! TxBuilder().drainTo(address: recipientAddressString).feeRate(satPerVbyte: 5).finish(wallet: wallet).serialize()
//        psbt = PSBT(base64: psbtBase64)!.urString
//    }
//    
//    var hasPSBT: Bool {
//        guard isSynced,
//              !psbt.isEmpty
//        else {
//            return false
//        }
//        return true
//    }
//}

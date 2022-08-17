import SwiftUI
import BCApp

struct ApproveOutputDescriptorResponse<AppViewModel: AppViewModelProtocol>: View {
    typealias Account = AppViewModel.Account
    typealias Slot = Account.Slot
    
    @Binding var isPresented: Bool
    let transactionID: CID
    let responseBody: OutputDescriptorResponseBody
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(spacing: 20) {
            Info("You have been sent an output descriptor.")
            TransactionChat(response: .none) {
                Rebus {
                    Symbol.outputDescriptor
                        .padding([.leading, .trailing], 20)
                }
            }
            
            GroupBox {
                Text(responseBody.descriptor.sourceWithChecksum)
                    .font(.caption)
            }
            
            if let (account, slot) = accountSlot {
                if isChallengeValid(slot: slot) {
                    slotInfo(account: account, slot: slot)
                } else {
                    Failure("The enclosed descriptor had an invalid signature.")
                }
            } else {
                Failure("This response does not match any account’s slot.")
            }
            
        }
        .navigationTitle("Output Descriptor")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    let (account, slot) = accountSlot!
                    slot.descriptor = responseBody.descriptor
                    account.updateStatus()
                    viewModel.saveChanges()
                    isPresented = false
                } label: {
                    Text("Save")
                }
                .disabled(!canSave)
            }
        }
    }
    
    func slotInfo(account: Account, slot: Slot) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Info("This output descriptor matches:")
            
            VStack(alignment: .leading) {
                Label("Account", icon: Image.account)
                    .formGroupBoxTitleFont()
                GroupBox {
                    ObjectIdentityBlock(model: .constant(account), allowLongPressCopy: false)
                        .frame(height: 80)
                }
            }

            VStack(alignment: .leading) {
                Label("Slot", icon: Image.slot)
                    .formGroupBoxTitleFont()
                GroupBox {
                    SlotListRow(slot: slot, hideIndex: account.slots.count == 1, hideDisclosure: true)
                }
                if let slotDescriptor = slot.descriptor {
                    if slotDescriptor == responseBody.descriptor {
                        Success("This slot already contains the same descriptor.")
                    } else {
                        Caution("This slot already contains a different descriptor. Saving this descriptor will replace the existing one.")
                    }
                }
            }
        }
    }
    
    var canSave: Bool {
        guard
            let (_, slot) = accountSlot,
            isChallengeValid(slot: slot),
            slot.descriptor != responseBody.descriptor
        else {
            return false
        }
        return true
    }
    
    func isChallengeValid(slot: Slot) -> Bool {
        guard
            let validationKey = responseBody.descriptor.hdKey(chain: .external, addressIndex: 0)?.ecPublicKey,
            validationKey.verify(message: slot.challenge, signature: responseBody.challengeSignature)
        else {
            return false
        }
        return true
    }
    
    var accountSlot: (Account, Slot)? {
        for account in viewModel.accounts {
            for slot in account.slots {
                if slot.slotID == transactionID {
                    return (account, slot)
                }
            }
        }
        return nil
    }
}

#if DEBUG

struct ApproveOutputDescriptorResponse_Host: View {
    @StateObject var viewModel: DesignTimeAppViewModel
    let transactionID: CID
    let responseBody: OutputDescriptorResponseBody

    init(invalidID: Bool = false, invalidChallenge: Bool = false, filledDifferent: Bool = false, filledSame: Bool = false) {
        let viewModel = DesignTimeAppViewModel()
        self._viewModel = StateObject(wrappedValue: viewModel)
        
        let account = viewModel.accounts.first!

        let slot = account.slots.first!
        
        if filledDifferent {
            slot.descriptor = randomDescriptor()
            account.updateStatus()
        }
        
        let useInfo = account.useInfo
        let masterKey = try! HDKey(HDKey(seed: Seed(), useInfo: useInfo))
        let accountNumber: UInt32 = 0
        let descriptor = try! AccountOutputType.wpkh.accountDescriptor(masterKey: masterKey, network: useInfo.network, account: accountNumber)
        
        if filledSame {
            slot.descriptor = descriptor
            account.updateStatus()
        }
                
        let signingKey = descriptor.hdKey(keyType: .private, chain: .external, addressIndex: 0) { key in
            try HDKey(parent: masterKey, childDerivationPath: key.parent)
        }!
        
        let challengeSignature = invalidChallenge ? SecureRandomNumberGenerator.shared.data(count: 64) : signingKey.ecPrivateKey!.ecdsaSign(message: slot.challenge)

        self.transactionID = invalidID ? CID() : slot.slotID
        self.responseBody = OutputDescriptorResponseBody(descriptor: descriptor, challengeSignature: challengeSignature)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ApproveOutputDescriptorResponse(isPresented: .constant(true), transactionID: transactionID, responseBody: responseBody, viewModel: viewModel)
            }
        }
    }
}

struct ApproveOutputDescriptorResponse_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ApproveOutputDescriptorResponse_Host()
                .previewDisplayName("Good")
            ApproveOutputDescriptorResponse_Host(invalidID: true)
                .previewDisplayName("Invalid ID")
            ApproveOutputDescriptorResponse_Host(invalidChallenge: true)
                .previewDisplayName("Invalid Challenge")
            ApproveOutputDescriptorResponse_Host(filledDifferent: true)
                .previewDisplayName("Filled Different")
            ApproveOutputDescriptorResponse_Host(filledSame: true)
                .previewDisplayName("Filled Same")
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#endif

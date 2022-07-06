import SwiftUI

struct ContentViewOld: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    Text("A")
                } label: {
                    Text("A")
                }
                NavigationLink {
                    Text("B")
                } label: {
                    Text("B")
                }
                NavigationLink {
                    Text("C")
                } label: {
                    Text("C")
                }
            }
        }
    }
}

//import SwiftUI
//import BCApp
//
//struct ContentView: View {
//    @StateObject var model: WalletSweeper = WalletSweeper()
//    @FocusState var fieldIsFocused: Bool
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 10) {
//                walletSection
//                transactionSection
//                psbtSection
//            }
//            .padding()
//        }
//        .onChange(of: model.isSyncing) {
//            if $0 {
//                fieldIsFocused = false
//            }
//        }
//    }
//    
//    var walletSection: some View {
//        VStack(alignment: .leading) {
//            descriptorSection
//            addressGapSection
//            syncButtonSection
//        }
//        .formSectionStyle()
//    }
//    
//    var descriptorSection: some View {
//        VStack(alignment: .leading) {
//            Text("Descriptor")
//                .formGroupBoxTitleFont()
//            TextEditor(text: $model.descriptorSource)
//                .autocapitalization(.none)
//                .keyboardType(.asciiCapable)
//                .disableAutocorrection(true)
//                .frame(height: 100)
//                .font(Font.system(.footnote).monospaced())
//                .focused($fieldIsFocused)
//                .disabled(model.isSyncing)
//            ErrorMessage(error: $model.descriptorValidation)
//        }
//    }
//    
//    var addressGapSection: some View {
//        VStack(alignment: .leading) {
//            Text("Address Gap")
//                .formGroupBoxTitleFont()
//            TextField("Address Gap", text: $model.addressGapText)
//                .keyboardType(.numberPad)
//                .formSectionStyle()
//            ErrorMessage(error: $model.addressGapValidation)
//        }
//    }
//    
//    @ViewBuilder var syncButtonSection: some View {
//        let syncButtonState = Binding<SyncButton.State> {
//            switch model.syncState {
//            case .needsSync:
//                return .stopped
//            case .syncing:
//                return .syncing
//            case .synced:
//                return .stopped
//            case .error:
//                return .error
//            }
//        } set: { _ in
//            fatalError()
//        }
//
//        let syncError = Binding<Error?> {
//            switch model.syncState {
//            case .error(let error):
//                return error
//            default:
//                return nil
//            }
//        } set: { _ in
//            fatalError()
//        }
//
//        VStack(alignment: .leading) {
//            SyncButton(action: model.updateBalance, state: syncButtonState)
//                .disabled(!model.canStartSync)
//            ErrorMessage(error: syncError)
//        }
//    }
//    
//    var transactionSection: some View {
//        VStack(alignment: .leading) {
//            balanceView
//            Spacer()
//                .frame(height: 10)
//            recipientSection
//        }
//        .formSectionStyle()
//        .opacity(model.isSynced ? 1 : 0)
//        .animation(.default, value: model.isSynced)
//    }
//    
//    var balanceView: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("Balance: ")
//                Symbol.bitcoin
//                Text(model.balanceString)
//                Spacer()
//            }
//            Text("Transactions: \(model.transactionCountString)")
//        }
//    }
//    
//    var recipientSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Recipient Address")
//                .formGroupBoxTitleFont()
//            TextField("Recipient Address", text: $model.recipientAddressString)
//                .keyboardType(.asciiCapable)
//                .font(Font.system(.footnote).monospaced())
//                .formSectionStyle()
//            ErrorMessage(error: $model.recipientAddressValidation)
//        }
//    }
//    
//    var psbtSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("PSBT")
//                .formGroupBoxTitleFont()
//            if let ur = try? UR(urString: model.psbt) {
//                URDisplay(ur: ur, name: "PSBT", maxFragmentLen: 600)
//            }
//        }
//        .formSectionStyle()
//        .opacity(model.hasPSBT ? 1 : 0)
//        .animation(.default, value: model.hasPSBT)
//    }
//}

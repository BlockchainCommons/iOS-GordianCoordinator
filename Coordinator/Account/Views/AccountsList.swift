import SwiftUI
import CoreData
import BCApp
import WolfBase
import WolfOrdinal
import LifeHash
import os

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountsList")

struct AccountsList<AppViewModel, Account>: View
where AppViewModel: AppViewModelProtocol, Account == AppViewModel.Account
{
    @ObservedObject var viewModel: AppViewModel
    
    @State private var isDetailValid: Bool = true
    @State private var accountForDeletion: Account?
    @State private var isAccountSetupPresented: Bool = false
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            list
                .frame(maxWidth: 600)
                .navigationTitle("Accounts")
                .sheet(isPresented: $isAccountSetupPresented) {
                    AccountSetup(isPresented: $isAccountSetupPresented) {
                        addItem($0)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: presentAccountSetup) {
                            Label("Add Account", icon: .add)
                        }
                    }
                }
                .toolbar {
                    AppToolbar(isTop: true)
                }
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    var list: some View {
        let isAlertPresented = Binding<Bool> {
            accountForDeletion != nil
        } set: { _ in
        }
        
        let accounts = viewModel.accounts
        if accounts.isEmpty {
            VStack {
                Spacer()
                    .frame(height: 20)
                Text("Tap the ") + Text(Image.add) + Text(" button above to add an ") + Text(Image.account) + Text(" account.")
                Spacer()
            }
            .padding()
        } else {
            List {
                ForEach(accounts) { account in
                    Item(account: account, isDetailValid: $isDetailValid, saveChanges: viewModel.saveChanges)
                        .swipeActions {
                            Button(role: .destructive) {
                                accountForDeletion = account
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onMove(perform: moveItem)
                .onDelete { _ in /* Handled by the swipe action and alert */ }
            }
            .alert("Delete Account",
                   isPresented: isAlertPresented,
                   presenting: accountForDeletion
            ) { account in
                Button(role: .destructive) {
                    deleteAccount(account)
                    accountForDeletion = nil
                } label: {
                    Text("Delete")
                }
                Button("Cancel", role: .cancel) {
                    accountForDeletion = nil
                }
            } message: { _ in
                Text("This action is not undoable.")
            }
        }
    }
    
    struct Item: View {
        @ObservedObject var account: Account
        @Binding var isDetailValid: Bool
        @StateObject var lifeHashState: LifeHashState
        let saveChanges: () -> Void
        
        init(account: Account, isDetailValid: Binding<Bool>, saveChanges: @escaping () -> Void) {
            self.account = account
            self._isDetailValid = isDetailValid
            self.saveChanges = saveChanges
            _lifeHashState = .init(wrappedValue: LifeHashState(input: account, version: .version2))
        }
        
        var body: some View {
            NavigationLink {
                AccountDetail(account: account, generateName: { Self.generateName(for: account) })
            } label: {
                VStack {
#if targetEnvironment(macCatalyst)
                    Spacer().frame(height: 10)
#endif
                    ObjectIdentityBlock(model: .constant(account), allowLongPressCopy: false)
                        .frame(height: 80)
                        .padding()
                    
#if targetEnvironment(macCatalyst)
                    Spacer().frame(height: 10)
                    Divider()
#endif
                }
            }
            .isDetailLink(true)
            .accessibility(label: Text("Account: \(account.accountID)"))
        }
        
        private static func generateName(for account: Account) -> String {
            LifeHashNameGenerator.generate(from: account.accountID)
        }
    }
    
    private func presentAccountSetup() {
        isAccountSetupPresented = true
    }
    
    private func addItem(_ setup: AccountSetupModel) {
        withAnimation {
            let ordinal: Ordinal
            let accounts = viewModel.accounts
            if accounts.isEmpty {
                ordinal = Ordinal()
            } else {
                ordinal = accounts.first!.ordinal.before
            }
            let account = viewModel.newAccount(accountID: setup.accountID, name: setup.name, policy: setup.policy, ordinal: ordinal)
            account.notes = setup.notes
            
            viewModel.saveChanges()
        }
    }
    
    private func deleteAccount(_ account: Account) {
        guard let index = viewModel.accounts.firstIndex(of: account) else {
            return
        }
        deleteAccounts(at: [index])
    }
    
    private func deleteAccounts(at offsets: IndexSet) {
        withAnimation {
            let accounts = viewModel.accounts
            offsets.map { accounts[$0] }.forEach(viewModel.deleteAccount)
            viewModel.saveChanges()
        }
    }
    
    private func moveItem(indices: IndexSet, newOffset: Int) {
        let index = Array(indices).sorted().first!
        guard index != newOffset else {
            return
        }
        
        let accounts = viewModel.accounts
        let account = accounts[index]
        if newOffset == 0 {
            account.ordinal = accounts.first!.ordinal.before
        } else if newOffset == accounts.count {
            account.ordinal = accounts.last!.ordinal.after
        } else {
            let beforeOrdinal = accounts[newOffset - 1].ordinal
            let afterOrdinal = accounts[newOffset].ordinal
            account.ordinal = Ordinal(after: beforeOrdinal, before: afterOrdinal)
        }
        viewModel.saveChanges()
    }
    
    var settingsButton: some View {
        Button {
        } label: {
            Image.settings
        }
        .font(.title)
        .padding([.top, .bottom, .leading], 10)
        .accessibility(label: Text("Settings"))
    }
}

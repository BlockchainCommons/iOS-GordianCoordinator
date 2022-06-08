import SwiftUI
import CoreData
import BCApp
import WolfBase
import WolfOrdinal
import os
import LifeHash

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountsList")

struct AccountsList: View {
    @ObservedObject var viewModel: AccountsViewModel
    
    @State private var isDetailValid: Bool = true
    @State private var selectionID: UUID? = nil
    @State private var accountForDeletion: Account?
    @State private var isAccountSetupPresented: Bool = false
    
    var viewContext: NSManagedObjectContext {
        viewModel.context
    }
    
    init(viewModel: AccountsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            list
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
                        Label("Add Account", systemImage: "plus")
                    }
                }
            }
            NoAccountSelected()
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                HStack(spacing: 10) {
                    UserGuideButton<AppChapter>()
                    ScanButton {
                    }
                }
                
                Spacer()
                
                Image.bcLogo
                    .accessibility(hidden: true)
                
                Spacer()
                
                Button {

                } label: {
                    Image.settings
                }
                .accessibility(label: Text("Settings"))
            }
        }
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
                    Item(account: account, isDetailValid: $isDetailValid, selectionID: $selectionID)
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
                    deleteItem(account: account)
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
        @Binding var selectionID: UUID?
        @StateObject var lifeHashState: LifeHashState

        init(account: Account, isDetailValid: Binding<Bool>, selectionID: Binding<UUID?>) {
            self.account = account
            self._isDetailValid = isDetailValid
            self._selectionID = selectionID
            _lifeHashState = .init(wrappedValue: LifeHashState(input: account, version: .version2))
        }

        var body: some View {
            NavigationLink(tag: account.accountID, selection: $selectionID) {
                AccountDetail(account: account, selectionID: $selectionID)
            } label: {
                VStack {
#if targetEnvironment(macCatalyst)
                    Spacer().frame(height: 10)
#endif
                    ObjectIdentityBlock(model: .constant(account), allowLongPressCopy: false)
                        .frame(height: 80)

#if targetEnvironment(macCatalyst)
                    Spacer().frame(height: 10)
                    Divider()
#endif
                }
            }
            .accessibility(label: Text("Account: \(account.accountID)"))
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
            let account = Account(context: viewContext, accountID: setup.accountID, policy: setup.policy, ordinal: ordinal)
            account.name = setup.name
            account.notes = setup.notes

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItem(account: Account) {
        guard let index = viewModel.accounts.firstIndex(of: account) else {
            return
        }
        deleteItems(offsets: [index])
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let accounts = viewModel.accounts
            offsets.map { accounts[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
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
        do {
            try viewContext.save()
        } catch {
            logger.error("⛔️ \(error.localizedDescription)")
        }
    }
    
    var settingsButton: some View {
        Button {
//            action?()
//            isPresented = true
        } label: {
            Image.settings
        }
        .font(.title)
        .padding([.top, .bottom, .leading], 10)
        .accessibility(label: Text("Settings"))
    }
    
    var leadingItems: some View {
        Text("leading")
//        HStack(spacing: 20) {
////            UserGuideButton<AppChapter>()
//            ScanButton {
////                presentedSheet = .scan(nil)
//            }
//        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountsList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}

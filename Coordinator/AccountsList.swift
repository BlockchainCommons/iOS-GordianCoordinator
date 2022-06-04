import SwiftUI
import CoreData
import BCApp
import WolfBase
import WolfOrdinal
import os
import LifeHash

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountsList")

struct AccountsList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var accounts: FetchedResults<Account>
    @State private var isDetailValid: Bool = true
    @State private var selectionID: UUID? = nil

    var sortedAccounts: [Account] {
        accounts.sorted()
    }

    var body: some View {
        NavigationView {
            list
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
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
                ForEach(sortedAccounts) { account in
                    Item(account: account, isDetailValid: $isDetailValid, selectionID: $selectionID)
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItems)
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
                Text("\(account)")
            } label: {
//            NavigationLink(destination: SeedDetail(seed: seed, saveWhenChanged: true, isValid: $isSeedDetailValid, selectionID: $selectionID), tag: seed.id, selection: $selectionID) {
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

    private func addItem() {
        withAnimation {
            let ordinal: Ordinal
            if accounts.isEmpty {
                ordinal = Ordinal()
            } else {
                ordinal = sortedAccounts.first!.ordinal.before
            }
            _ = Account(context: viewContext, policy: .threshold(quorum: 2, signers: 3), ordinal: ordinal)

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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            let accounts = sortedAccounts
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

        let account = sortedAccounts[index]
        if newOffset == 0 {
            account.ordinal = sortedAccounts.first!.ordinal.before
        } else if newOffset == sortedAccounts.count {
            account.ordinal = sortedAccounts.last!.ordinal.after
        } else {
            let beforeOrdinal = sortedAccounts[newOffset - 1].ordinal
            let afterOrdinal = sortedAccounts[newOffset].ordinal
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsList().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

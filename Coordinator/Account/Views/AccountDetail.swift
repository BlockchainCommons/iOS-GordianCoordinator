import SwiftUI
import BCApp
import os
import WolfBase
import WolfOrdinal
import WolfSwiftUI

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountDetail")

struct AccountDetail<Account: AccountProtocol>: View {
    @ObservedObject var account: Account
    @EnvironmentObject var persistence: Persistence
    let generateName: () -> String

    @FocusState var focusedField: UUID?
    @State var isNameValid: Bool = true
    @State var name: String = ""
    @State var notes: String = ""
    
    var isValid: Bool {
        isNameValid
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                identity
                slots
                nameEditor
                notesEditor
            }
        }
        .navigationTitle("Account")
        .frame(maxWidth: 600)
        .padding()
        .toolbar {
            KeyboardToolbar {
                focusedField = nil
            }
        }
        .onAppear {
            self.name = account.name
            self.notes = account.notes
//            setScanVisible(false)
        }
    }
    
    func onValid() {
        account.name = name
        account.notes = notes
        persistence.saveChanges()
    }
    
    var identity: some View {
        ObjectIdentityBlock(model: .constant(account))
            .frame(height: 128)
    }
    
//    var address: some View {
//        AccountAddress(account: account)
//    }

    var slots: some View {
        SlotList(account: account)
    }

    var nameEditor: some View {
        NameEditor($name, isValid: $isNameValid, focusedField: _focusedField, onValid: onValid, generateName: generateName)
    }

    var notesEditor: some View {
        NotesEditor($notes, focusedField: _focusedField, onValid: onValid)
    }
}

#if DEBUG

struct AccountDetail_Host: View {
    @StateObject var account = {
        let a = DesignTimeAccount(model: nil, accountID: UUID(), name: "Test account", policy: .threshold(quorum: 2, slots: 3), ordinal: [0], isComplete: false)
        a.slots.first!.descriptor = randomDescriptor()
        a.updateStatus()
        return a
    }()

    var body: some View {
        AccountDetail(account: account, generateName: { LifeHashNameGenerator.generate(from: account.accountID) })
    }
}

struct AccountDetail_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AccountDetail_Host()
            }
        }
        .padding()
        .preferredColorScheme(.dark)
        .environmentObject(Clipboard(isDesignTime: true))
        .environmentObject(Persistence(isDesignTime: true))
    }
}

#endif

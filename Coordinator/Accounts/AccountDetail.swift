import SwiftUI
import BCApp
import os
import WolfBase
import WolfOrdinal

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountDetail")

struct AccountDetail<Account: AccountProtocol>: View {
    @ObservedObject var account: Account
    let onValid: () -> Void
    let generateName: () -> String

    @FocusState var focusedField: UUID?
    @State var isNameValid: Bool = true
    @State var isNotesValid: Bool = true
    
    var isValid: Bool {
        isNameValid && isNotesValid
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                identity
                slots
                name
                notes
            }
        }
        .navigationTitle("Account")
        .frame(maxWidth: 600)
        .padding()
        .toolbar {
            AppToolbar()
        }
    }
    
    var identity: some View {
        ObjectIdentityBlock(model: .constant(account))
            .frame(height: 128)
    }

    @ViewBuilder
    var name: some View {
        NameEditor($account.name, isValid: $isNameValid, focusedField: _focusedField) {
            onValid()
        } generateName: {
            generateName()
        }
    }

    var notes: some View {
        NotesEditor($account.notes, isValid: $isNotesValid, focusedField: _focusedField) {
            onValid()
        }
    }

    var slots: some View {
        SlotList(slots: account.slots)
    }
}

#if DEBUG

struct AccountDetail_Host: View {
    @StateObject var account: DesignTimeAccount

    var body: some View {
        AccountDetail(account: account, onValid: { }, generateName: { LifeHashNameGenerator.generate(from: account.accountID) })
    }
}

struct Example_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AccountDetail_Host(account: DesignTimeAccount(accountID: UUID(), name: "Foo bar", notes: "", policy: .threshold(quorum: 2, slots: 3), ordinal: Ordinal()))
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}
#endif

import SwiftUI
import BCApp
import os
import WolfBase
import WolfOrdinal
import WolfSwiftUI

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AccountDetail")

struct AccountDetail<Account: AccountProtocol>: View {
    @ObservedObject var account: Account
    let onValid: () -> Void
    let generateName: () -> String

    @FocusState var focusedField: UUID?
    @State var isNameValid: Bool = true
    
    var isValid: Bool {
        isNameValid
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
            KeyboardToolbar {
                focusedField = nil
            }

            AppToolbar()
        }
    }
    
    var identity: some View {
        ObjectIdentityBlock(model: .constant(account))
            .frame(height: 128)
    }

    var name: some View {
        NameEditor($account.name, isValid: $isNameValid, focusedField: _focusedField, onValid: onValid, generateName: generateName)
    }

    var notes: some View {
        NotesEditor($account.notes, focusedField: _focusedField, onValid: onValid)
    }

    var slots: some View {
        SlotList(account: account, onValid: onValid)
    }
}

#if DEBUG

struct AccountDetail_Host: View {
    @StateObject var account = DesignTimeAccount(model: nil, accountID: UUID(), name: "Test account", policy: .threshold(quorum: 2, slots: 3), ordinal: [0])

    var body: some View {
        AccountDetail(account: account, onValid: { }, generateName: { LifeHashNameGenerator.generate(from: account.accountID) })
    }
}

struct Example_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AccountDetail_Host()
        }
        .padding()
        .preferredColorScheme(.dark)
        .environmentObject(Clipboard(isDesignTime: true))
    }
}

#endif

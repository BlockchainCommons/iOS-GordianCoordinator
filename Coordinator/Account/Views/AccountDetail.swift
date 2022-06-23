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
                address
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

            AppToolbar()
        }
        .onAppear {
            self.name = account.name
            self.notes = account.notes
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
    
    var address: some View {
        AccountAddress(account: account)
    }

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

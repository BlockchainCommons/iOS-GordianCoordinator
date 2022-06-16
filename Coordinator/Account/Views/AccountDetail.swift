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
    
    func onValid() {
        
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
        SlotList(account: account)
    }
}

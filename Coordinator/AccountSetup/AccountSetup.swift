import SwiftUI
import BCApp
import WolfSwiftUI
import LifeHash
import WolfBase

struct AccountSetup: View {
    @Binding var isPresented: Bool
    let save: (AccountSetupModel) -> Void
    @StateObject var model = AccountSetupModel()
    @FocusState var focusedField: UUID?
    @State var isNameValid: Bool = true
    @State var shouldSave: Bool = false
    
    var isValid: Bool {
        isNameValid
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    identity
                    network
                    policy
                    name
                    notes
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    CancelButton($isPresented)
                }
                ToolbarItem(placement: .confirmationAction) {
                    SaveButton {
                        shouldSave = true
                        isPresented = false
                    }
                    .disabled(!isValid)
                }
            }
            .onDisappear {
                guard shouldSave else {
                    return
                }
                save(model)
            }
            .navigationTitle("Account Setup")
            .frame(maxWidth: 600)
            .padding()
        }
    }
    
    var network: some View {
//        EmptyView()
        NetworkPicker(selectedNetwork: Binding($model.network))
    }

    var identity: some View {
        ObjectIdentityBlock(model: .constant(model))
            .frame(height: 128)
    }
    
    @ViewBuilder
    var policy: some View {
        let preset = Binding<PolicyPreset?>(
            get: {
                switch model.policy {
                case .single:
                    return .single
                case .threshold(let quorum, let slots):
                    switch (quorum, slots) {
                    case (2, 3):
                        return .threshold2of3
                    case (3, 5):
                        return .threshold3of5
                    case (4, 9):
                        return .threshold4of9
                    default:
                        return nil
                    }
                }
            }, set: { newValue in
                switch newValue {
                case .single:
                    model.policy = .single
                case .threshold2of3:
                    model.policy = .threshold(quorum: 2, slots: 3)
                case .threshold3of5:
                    model.policy = .threshold(quorum: 3, slots: 5)
                case .threshold4of9:
                    model.policy = .threshold(quorum: 4, slots: 9)
                default:
                    model.policy = .threshold(quorum: 1, slots: 1)
                }
            }
        )
        PolicyPicker(selectedPreset: preset)
    }
    
    @ViewBuilder
    var name: some View {
        NameEditor($model.name, isValid: $isNameValid, generateName: {
            LifeHashNameGenerator.generate(from: model.accountID)
        })
    }
    
    var notes: some View {
        NotesEditor($model.notes, focusedField: _focusedField)
    }
}

#if DEBUG

struct AccountSetup_Preview: PreviewProvider {
    static var previews: some View {
        AccountSetup(isPresented: .constant(true)) { _ in
            // save
        }
        .padding()
        .preferredColorScheme(.dark)
    }
}

#endif

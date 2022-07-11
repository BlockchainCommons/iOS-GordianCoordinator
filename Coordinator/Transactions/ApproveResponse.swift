import SwiftUI
import BCApp
import WolfSwiftUI

struct ApproveResponse: View {
    @Binding var isPresented: Bool
    let response: TransactionResponse
    
    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    switch response.body {
                    case .outputDescriptor(let responseBody):
                        ApproveOutputDescriptorResponse(transactionID: response.id, responseBody: responseBody)
                    default:
                        ResultScreen<Void, GeneralError>(isPresented: $isPresented, result: .failure(.init("Unknown response.")))
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    DoneButton($isPresented)
                }
            }
            .copyConfirmation()
        }
    }
}

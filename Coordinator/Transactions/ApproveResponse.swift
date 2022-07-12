import SwiftUI
import BCApp
import WolfSwiftUI

struct ApproveResponse<AppViewModel: AppViewModelProtocol>: View {
    @Binding var isPresented: Bool
    let response: TransactionResponse
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                Group {
                    switch response.body {
                    case .outputDescriptor(let responseBody):
                        ApproveOutputDescriptorResponse(isPresented: $isPresented, transactionID: response.id, responseBody: responseBody, viewModel: viewModel)
                    default:
                        ResultScreen<Void, GeneralError>(isPresented: $isPresented, result: .failure(.init("Unknown response.")))
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    CancelButton($isPresented)
                }
            }
            .copyConfirmation()
        }
    }
}

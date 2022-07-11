import SwiftUI
import BCApp

struct ApproveOutputDescriptorResponse: View {
    let transactionID: UUID
    let responseBody: OutputDescriptorResponseBody
    
    var body: some View {
        VStack {
            TransactionChat(response: .none) {
                Rebus {
                    Symbol.outputDescriptor
                    Symbol.receivedItem
                }
            }
            Text("Approve")
        }
    }
}

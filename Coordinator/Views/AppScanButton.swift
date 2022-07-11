import SwiftUI
import BCApp
import os
import WolfSwiftUI

fileprivate let logger = Logger(subsystem: Application.bundleIdentifier, category: "AppScanButton")

struct AppScanButton: View {
    @State var isPresented = false
    @State var presentedResponse: TransactionResponse?
    @State var isUnknownPresented = false
    
    var body: some View {
        let isResponsePresented = Binding<Bool>(
            get: {
                presentedResponse != nil
            },
            set: {
                if $0 == false {
                    presentedResponse = nil
                }
            }
        )
        ScanButton {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            Scan(isPresented: $isPresented, prompt: "Scan a QR code to receive a response from another device.") { result in
                print("result: \(result)")
                switch result {
                case .response(let response):
                    presentedResponse = response
                case .failure(let error):
                    logger.error("⛔️ scan failure: \(error.localizedDescription)")
                default:
                    isUnknownPresented = true
                }
            }
        }
        .background(
            Color.clear
                .sheet(isPresented: isResponsePresented) {
                    ApproveResponse(isPresented: isResponsePresented, response: presentedResponse!)
                }
        )
        .background(
            Color.clear
                .sheet(isPresented: $isUnknownPresented) {
                    ResultScreen<Void, GeneralError>(isPresented: $isUnknownPresented, result: .failure(GeneralError("Unrecognized message.")))
                }
        )
    }
}

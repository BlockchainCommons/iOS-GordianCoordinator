import SwiftUI
import BCApp
import WolfBase

struct ErrorMessage: View {
    @Binding var error: Error?
    
    var body: some View {
        Group {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .errorStyle()
            } else {
                EmptyView()
            }
        }
        .opacity(hasError ? 1 : 0)
        .animation(.default, value: hasError)
    }
    
    var errorMessage: String? {
        if let error = error {
            if let error = error as? LocalizedError {
                return error.errorDescription ?? "Unknown error."
            } else {
                return error†
            }
        }
        
        return nil
    }
    
    var hasError: Bool {
        return error != nil
    }
}

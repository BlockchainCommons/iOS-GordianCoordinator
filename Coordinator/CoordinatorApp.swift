import SwiftUI

let initializeCloudKitSchema = false

@main
struct CoordinatorApp: App {
    var body: some Scene {
        WindowGroup {
            if initializeCloudKitSchema {
                Text("Initializing CloudKit Schema...")
                    .font(.title)
                Text("Stop after Xcode says 'no more requests to execute', then use CloudKit Console to ensure the schema was created correctly.")
                    .padding()
                    .onAppear {
                        Persistence.setupContainer(initializeCloudKitSchema: true)
                    }
            } else {
                MainView()
                    .symbolRenderingMode(.hierarchical)
                    .environmentObject(Clipboard())
            }
        }
    }
}

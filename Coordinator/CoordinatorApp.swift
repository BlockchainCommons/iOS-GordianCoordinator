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
                        _ = PersistenceController.shared.container
                    }
            } else {
                AccountsList()
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    .symbolRenderingMode(.hierarchical)
            }
        }
    }
}

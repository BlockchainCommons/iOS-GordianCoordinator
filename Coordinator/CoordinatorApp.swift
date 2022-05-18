//
//  CoordinatorApp.swift
//  Coordinator
//
//  Created by Wolf McNally on 5/18/22.
//

import SwiftUI

@main
struct CoordinatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

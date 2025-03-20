//
//  GroceryTrackaApp.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/19/25.
//

import SwiftUI

@main
struct GroceryTrackaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

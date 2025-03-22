//
//  GroceryTrackaApp.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/19/25.
//

import SwiftUI
import CoreData




@main
struct GroceryTrackaApp: App {
    let persistenceController = Persistence.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

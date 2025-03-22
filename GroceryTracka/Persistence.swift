//
//  Persistence.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import CoreData

struct Persistence {
    static let shared = Persistence()

    @MainActor
    static let preview: Persistence = {
        let result = Persistence(inMemory: true)
        let viewContext = result.container.viewContext

        do {
            // Add a sample item for previews
            let sampleItem = GroceryItem(context: viewContext)
            sampleItem.itemName = "Sample Grocery Item"
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error (nsError), (nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "GroceryModel") 
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error (error), (error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

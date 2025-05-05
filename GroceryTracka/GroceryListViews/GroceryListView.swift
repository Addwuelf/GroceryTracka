//
//  GroceryListView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/19/25.
//

import SwiftUI
import CoreData

// Displays all of the users groceryItems. Also lets user manage items.
struct GroceryListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: GroceryItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GroceryItem.itemName, ascending: true)],
        animation: .default)
    private var items: FetchedResults<GroceryItem>
    
    
    
    // Grocery Items Placeholder
    @State var groceryItems = ["Chicken", "Milk", "Banana"]
    @State var showAddItemOverlay = false
    @State var newItemName = ""
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    
                    List {
                        ForEach(items) { item in
                            NavigationLink(destination: RecipeListView(ingredient: item.itemName ?? "Chicken"))
                            {
                                Text(item.itemName ?? "default value")
                                
                            }
                        }
                        .onDelete(perform: deleteItem)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal){
                        Text("Grocery List")
                            .font(.largeTitle)
                           
                    }
                    // Allows user to delete items
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    // When clicked displays GroceryEditView where they can add new item
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: GroceryEditView(passedGroceryItem: nil)){
                            Text(" + ")
                                .font(.headline)
                        }
                    }
                }
       //
            }
            
        }
        
        
        
        
    }
    
    func deleteItem(at offsetss: IndexSet) {
        offsetss.map {items[$0]}.forEach(viewContext.delete)
        
        saveContext(viewContext)
        
    }
    
    func saveContext(_ context: NSManagedObjectContext ) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
        }
    }
    
}
struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryListView()
    }
}
        
    

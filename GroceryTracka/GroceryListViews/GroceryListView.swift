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
    
    @State private var selectedItem: GroceryItem?
    @State private var selectedRecipe: String?
    @State private var isEditing = false
    @State private var isViewingRecipe = false
    
    // Grocery Items Placeholder
    @State var groceryItems = ["Chicken", "Milk", "Banana"]
    @State var showAddItemOverlay = false
    @State var newItemName = ""
    var body: some View {
        VStack(spacing: 0) {
            Text("Grocery List").font(.largeTitle)
            NavigationStack() {
                ZStack{
                    VStack {
                        List {
                            ForEach(items) { item in
                                HStack {
                                    // Edit View Triggered by Clicking the Text
                                    Text(item.itemName ?? "default value")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .onTapGesture {
                                            selectedItem = item
                                            isEditing = true
                                        }

                                    Spacer()

                                    // Recipe View Triggered by Clicking the Info Icon
                                    Button(action: {
                                        selectedRecipe = item.itemName ?? "Chicken"
                                        isViewingRecipe = true
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                }
                            }
                            .onDelete(perform: deleteItem)
                            .sheet(isPresented: $isEditing) {
                                if let item = selectedItem {
                                    GroceryEditView(passedGroceryItem: item)
                                }
                            }
                            .sheet(isPresented: $isViewingRecipe) {
                                if let ingredient = selectedRecipe {
                                    RecipeListView(ingredient: ingredient)
                                }
                            }
                        }
                    }
                    
                    .toolbar() {
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
        
    

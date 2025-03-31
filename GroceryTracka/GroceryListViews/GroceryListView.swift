//
//  GroceryListView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/19/25.
//

import SwiftUI
import CoreData

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
                        
                        FloatingButton()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .principal){
                        Text("Grocery List")
                            .font(.largeTitle)
                           
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
      
                
                
                if showAddItemOverlay {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showAddItemOverlay = false
                        }
                    
                    VStack(spacing: 20) {
                        Text("Add New Item")
                            .font(.headline)
                        
                        TextField("Enter Item Name", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        HStack {
                            Button("Cancel") {
                                showAddItemOverlay = false
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Button("Add"){
                                if !newItemName.isEmpty {
                                    groceryItems.append(newItemName)
                                    newItemName = ""
                                    showAddItemOverlay = false
                                }
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    
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
        
    



import SwiftUI
import CoreData


struct Contetview: View {
    @State var logged = false
    @State private var selectedItem: GroceryItem?
    @State private var selectedList: GroceryList?
    @State var itemName = ""
    
    var body: some View {
        if logged {
            RecipeListView(ingredient: itemName)
        }
        else {
            GroceryListView(itemName: $itemName, logged: $logged, selectedItem: $selectedItem, selectedList: $selectedList)
        }
    }
}

// Displays all of the users groceryItems. Also lets user manage items.
struct GroceryListView: View {
    
    @Binding var itemName: String
    @Binding var logged : Bool
    @Binding var selectedItem: GroceryItem?
    @Binding var selectedList: GroceryList?
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: GroceryItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GroceryItem.itemName, ascending: true)],
        animation: .default)
    private var itemss: FetchedResults<GroceryItem>
    
    @State private var selectedRecipe: String?
    @State private var isEditing = false
    @State private var isViewingRecipe = false
    
    // Grocery Items Placeholder
    @State var groceryItems = ["Chicken", "Milk", "Banana"]
    @State var showAddItemOverlay = false
    @State var newItemName = ""
    
    private var items: [GroceryItem] {
        guard let itemSet = selectedList?.items as? Set<GroceryItem> else {
            return []
        }
        return itemSet.sorted { $0.itemName ?? "" < $1.itemName ?? "" }
    }
    
    
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
                                    NavigationLink(destination: GroceryEditView(passedGroceryItem: item, selectedList: $selectedList)) {
                                        Text(item.itemName ?? "default value")
                                            .contentShape(Rectangle())
                                    }

                                        // Recipe View Triggered by Clicking the Info Icon
                                        Button(action: {
                                            itemName = item.itemName ?? "Chicken"
                                            
                                            logged = true
                                        }) {
                                            Image(systemName: "info.circle")
                                                .foregroundColor(.blue)
                                                .padding()
                                        }
                                        .buttonStyle(BorderedButtonStyle())
                                }
                            }
                            .onDelete(perform: deleteItem)
                           
                        }
                    }
                    
                    .toolbar() {
                        // Allows user to delete items
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        // When clicked displays GroceryEditView where they can add new item
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: GroceryEditView(passedGroceryItem: nil, selectedList: $selectedList)){
                                Text(" + ")
                                    .font(.headline)
                            }
                        }
                    }
                    
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
      
    }
}
        
    

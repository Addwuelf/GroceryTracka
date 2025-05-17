

import SwiftUI
import CoreData

struct Contetview: View {
    @ObservedObject var viewModel: GroceryListViewModel
    @State var logged = false
    @State private var selectedItem: GroceryItem?
    @State var itemName = ""
    
    var body: some View {
        if logged {
            RecipeListView(ingredient: itemName)
        }
        else {
            GroceryListView(viewModel: viewModel,itemName: $itemName, logged: $logged, selectedItem: $selectedItem)
                .onAppear(
                    
                )
        }
    }
}

// Displays all of the users groceryItems. Also lets user manage items.
struct GroceryListView: View {
    
    @ObservedObject var viewModel: GroceryListViewModel
    @Binding var itemName: String
    @Binding var logged: Bool
    @Binding var selectedItem: GroceryItem?
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            entity: SavedSettings.entity(),
            sortDescriptors: []
    ) private var entities: FetchedResults<SavedSettings>
    
    
    private var itemss: [GroceryItem] {
            guard let itemSet = viewModel.selectedGroceryList?.items as? Set<GroceryItem> else {
                return []
            }
            return itemSet.sorted { $0.itemName ?? "" < $1.itemName ?? "" }
        }
    
    @State private var expandedCategories: [String: Bool] = [:]
    
    // Extracts unique category names from items
    private var categoryNames: [String] {
        Array(Set(itemss.compactMap { $0.category ?? "Uncategorized" })).sorted()
    }
    
    // Precomputes grouped items for better performance
    private var groupedItems: [String: [GroceryItem]] {
        Dictionary(grouping: itemss, by: { $0.category ?? "Uncategorized" })
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Grocery List").font(.largeTitle)
            NavigationStack {
                List {
                    ForEach(categoryNames, id: \.self) { category in
                        Section(header: Text(category).font(.headline)) {
                            let filteredItems = groupedItems[category] ?? [] // Precompute filtered items here
                            ForEach(filteredItems, id: \.self) { item in
                                HStack {
                                    NavigationLink(destination: GroceryEditView(passedGroceryItem: item, viewModel: viewModel)) {
                                        Text(item.itemName ?? "default value")
                                    }
                                    .onAppear {
                                        
                                    }
                                    
                                    Button(action: {
                                        itemName = item.itemName ?? "default"
                                        logged = true
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                    .buttonStyle(BorderedButtonStyle())
                                }
                            }
                            .onDelete { indexSet in deleteItem(at: indexSet, for: category) }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: GroceryEditView(passedGroceryItem: nil, viewModel: viewModel)) {
                            Text(" + ")
                                .font(.headline)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Settings()) {
                            Text(" ] ")
                                .font(.headline)
                        }
                    }
                }
            }
        }
    }
    
    // Corrected delete function to remove items by category
    func deleteItem(at offsets: IndexSet, for category: String) {
        guard let categoryItems = groupedItems[category] else { return }
        let itemsToDelete = offsets.map { categoryItems[$0] }
        
        itemsToDelete.forEach { viewContext.delete($0) }
        
        saveContext()
        
        DispatchQueue.main.async {
            viewModel.objectWillChange.send()
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
        }
    }




// Ensure categories exist on app startup
    private func ensureDefaultCategoriesExist() {
        let existingCategories = entities.compactMap { $0.infos }.flatMap { $0 }

        if existingCategories.isEmpty {
            let predefinedCategories = ["","Produce", "Dairy", "Meat", "Snack"]
            predefinedCategories.forEach { addCategory(name: $0) }
        }
    }

    // Function to add a new category
    private func addCategory(name: String) {
        let newSavedCategory = SavedSettings(context: viewContext)
        newSavedCategory.wrappedInfos.append(name)
        saveContext()
    }


}


struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
      
    }
}
        
    

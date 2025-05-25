

import SwiftUI
import CoreData

struct Contetview: View {
    @ObservedObject var viewModel: GroceryListViewModel
    @State var logged = false
    @State private var selectedItem: GroceryItem?
    @State var itemName = ""
    
    var body: some View {
            NavigationStack {
                GroceryListView(viewModel: viewModel, itemName: itemName, logged: $logged, selectedItem: $selectedItem)
            }
        }
}

// Displays all of the users groceryItems. Also lets user manage items.
struct GroceryListView: View {
    
    @ObservedObject var viewModel: GroceryListViewModel
    @State var itemName: String
    @Binding var logged: Bool
    @Binding var selectedItem: GroceryItem?
    @State private var navigateToRecipe = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            entity: SavedSettings.entity(),
            sortDescriptors: []
    ) private var entities: FetchedResults<SavedSettings>
    @FetchRequest(
            entity: SavedColors.entity(),
            sortDescriptors: []
    ) private var colors: FetchedResults<SavedColors>
    
    
    private var itemss: [GroceryItem] {
            guard let itemSet = viewModel.selectedGroceryList?.items as? Set<GroceryItem> else {
                return []
            }
            return itemSet.sorted { $0.itemName ?? "" < $1.itemName ?? "" }
        }
    
    @State private var categoryColor: Color = .white
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
            NavigationStack {
                List {
                    ForEach(categoryNames, id: \.self) { category in
                        Section(header: Text(category).font(.headline).background(loadSavedColor()).foregroundStyle(.white)) {
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
                                        navigateToRecipe = true
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
                            Image(systemName: "gear")
                                .foregroundColor(.blue)
                        }
                    }
                }
            
            }
            
        }
        .background(
                        NavigationLink(
                            destination: RecipeListView(ingredient: $itemName, viewModel: viewModel),
                            isActive: $navigateToRecipe
                        ) { EmptyView() }
                            .hidden()
                    )
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
            let predefinedCategories = ["Uncategorized","Produce", "Dairy", "Meat", "Snack", "Bread"]
            predefinedCategories.forEach { addCategory(name: $0) }
        }
    }

    // Function to add a new category
    private func addCategory(name: String) {
        let newSavedCategory = SavedSettings(context: viewContext)
        newSavedCategory.wrappedInfos.append(name)
        saveContext()
    }
    
    func loadSavedColor() -> Color {
        
        guard let col = colors.first else {
            return .cyan
        }
        do {
            let red = Double(col.catred) / 255.0
            let green = Double(col.catgreen) / 255.0
            let blue = Double(col.catblue) / 255.0

            return Color(red: red, green: green, blue: blue)
            
        }

    }


}


struct GroceryListView_Previews: PreviewProvider {
    static var previews: some View {
      
    }
}
        
    

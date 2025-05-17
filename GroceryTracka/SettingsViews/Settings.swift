

import SwiftUI
import CoreData


struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: SavedSettings.entity(), sortDescriptors: [])
    private var entities: FetchedResults<SavedSettings>

    @State private var showingDeleteAlert = false
    @State private var selectedCategory: String? // Track which category is tapped
    @State var newCategory: String = ""

    var body: some View {
        VStack {
            Form {
                ColorPicker("Background color", selection: .constant(.red))
                
                // Categories List
                DisclosureGroup("Categories") {
                    ForEach(getAllCategories(), id: \.self) { category in
                        Text(category)
                            .onTapGesture {
                                selectedCategory = category
                                showingDeleteAlert = true
                            }
                    }
                }
                .alert("Delete Category", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        if let category = selectedCategory {
                            deleteCategory(name: category)
                        }
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("Are you sure you want to delete this category?")
                }
                
                // Add Category Section
                Section("Add Category") {
                    HStack {
                        TextField("Category Name", text: $newCategory)
                        Button("Add") {
                            addCategory(name: newCategory)
                            newCategory = ""
                        }
                    }
                }
            }
        }
    }

    // Fetch all categories from Core Data
    func getAllCategories() -> [String] {
        var savedCategoryNames = entities.compactMap { $0.infos }.flatMap { $0 }
        if savedCategoryNames.isEmpty {
            let predefinedCategories = ["", "Produce", "Dairy", "Meat", "Snack"]
            predefinedCategories.forEach { addCategory(name: $0) }
            return predefinedCategories
        }
        return savedCategoryNames
    }

    // Add a new category
    func addCategory(name: String) {
        let newSavedCategory = SavedSettings(context: viewContext)
        if !name.isEmpty {
            newSavedCategory.wrappedInfos.append(name)
        }
        saveContext()
    }

    // Delete a category (Remove it from Core Data)
    func deleteCategory(name: String) {
        for entity in entities {
            if entity.wrappedInfos.contains(name) {
                entity.wrappedInfos.removeAll { $0 == name } // Remove the category

                viewContext.refresh(entity, mergeChanges: true) // Mark changes
                saveContext()

                break
            }
        }
    }

    // Save changes to Core Data
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error (nsError) (nsError.userInfo)")
        }
    }
}

#Preview {
    Settings( newCategory: "")
}

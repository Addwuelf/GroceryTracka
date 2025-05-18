

import SwiftUI
import CoreData


struct Settings: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: SavedSettings.entity(), sortDescriptors: [])
    private var entities: FetchedResults<SavedSettings>
    
    @FetchRequest(entity: SavedColors.entity(), sortDescriptors: [])
    private var colors: FetchedResults<SavedColors>
    @State private var categoryColor: Color = .red
    @State private var showingDeleteAlert = false
    @State private var selectedCategory: String? // Track which category is tapped
    @State var newCategory: String = ""

    var body: some View {
        VStack {
            Form {
                ColorPicker("Background color", selection: $categoryColor)
                    .onAppear {
                        if let savedColor = colors.first {
                            categoryColor = loadCategoryColor(from: savedColor)
                        }
                    }
                    .onChange(of: categoryColor) { newColor in
                        saveCategoryColor(newColor)
                    }
                    
                
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
        let savedCategoryNames = entities.compactMap { $0.infos }.flatMap { $0 }
        if savedCategoryNames.isEmpty {
            let predefinedCategories = ["Uncategorized", "Produce", "Dairy", "Meat", "Snack"]
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
    
    func saveCategoryColor(_ color: Color) {
        let uiColor = UIColor(color)
        guard let components = uiColor.cgColor.components else { return }

        let newColor = colors.first
        newColor?.catred = Int16(components[0] * 255) // Red
        newColor?.catgreen = Int16(components[1] * 255) // Green
        newColor?.catblue = Int16(components[2] * 255) // Blue

        do {
            try viewContext.save()
        } catch {
            print("Error saving color: (error)")
        }
    }
    
    func loadCategoryColor(from colors: SavedColors) -> Color {
        let red = Double(colors.catred) / 255.0
        let green = Double(colors.catgreen) / 255.0
        let blue = Double(colors.catblue) / 255.0

        return Color(red: red, green: green, blue: blue)
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

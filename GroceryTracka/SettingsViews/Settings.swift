

import SwiftUI
import CoreData


struct Settings: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
            entity: SavedSettings.entity(),
            sortDescriptors: []
    ) private var entities: FetchedResults<SavedSettings>
    
  
    

    @State var newCategory: String = ""
    
    var body: some View {
        Text("Hello, World!")
        VStack {
            Form {
                ColorPicker("Background color", selection: .constant(.red))
                DisclosureGroup("Categories") {
                    ForEach(getAllCategories(), id: \.self) { category in
                        Text(category)
                    }
                }
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
    
    func getAllCategories() -> [String] {
            var savedCategoryNames = entities.compactMap { $0.infos }.flatMap { $0 }

            if savedCategoryNames.isEmpty {
                let predefinedCategories = ["Produce", "Dairy", "Meat", "Snack"]

                for category in predefinedCategories {
                    addCategory(name: category)
                }

                return predefinedCategories
            }

            return savedCategoryNames
        }
    
    func addCategory(name: String) {
        let newSavedCategory = SavedSettings(context: viewContext)
        if(name != "") {
            newSavedCategory.wrappedInfos.append(name)
    }
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

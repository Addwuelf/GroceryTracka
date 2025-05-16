

import SwiftUI


struct Settings: View {
    
    var categories: [String] = ["Produce", "Dairy", "Meat", "Snack"]
    
    @State var newCategory: String = ""
    
    var body: some View {
        Text("Hello, World!")
        VStack {
            Form {
                ColorPicker("Background color", selection: .constant(.red))
                DisclosureGroup("Categories") {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                Section("Add Category") {
                    
                    HStack {
                        TextField("Category Name", text: $newCategory)
                        
                        Button("Add", action: addCategory)
                    }
                }
                
            }
        }
    }
     func addCategory() {
         var new = newCategory
         categories.append()
    }
}

#Preview {
    Settings( newCategory: "")
}

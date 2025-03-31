//
//  GroceryEditView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import SwiftUI

struct GroceryEditView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedGroceryItem: GroceryItem?
    @State var itemName: String
    
    init(passedGroceryItem: GroceryItem?) {
        
        if let groceryItem = passedGroceryItem {
            _selectedGroceryItem = State(initialValue: groceryItem)
            _itemName = State(initialValue: groceryItem.itemName ?? "")
        }
        else {
            _itemName = State(initialValue: "")
        }
    }
    var body: some View {
        Form {
            Section(header: Text("Item")) {
                TextField("Item Name", text: $itemName )
            }
            Section()
            {
                Button("Add", action: addAction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    func addAction() {
        withAnimation {
            if selectedGroceryItem == nil {
                selectedGroceryItem = GroceryItem(context: viewContext)
            }
            
            selectedGroceryItem?.itemName = itemName
            self.presentationMode.wrappedValue.dismiss()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
            }
        }
    }
    
}

struct GroceryEditView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryEditView(passedGroceryItem: GroceryItem())
    }
}

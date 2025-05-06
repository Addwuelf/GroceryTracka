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
    @State var itemAmount: Double
    @State private var amount = ""
    @State private var itemCategory = ""


    
    init(passedGroceryItem: GroceryItem?) {
        
        if let groceryItem = passedGroceryItem {
            _selectedGroceryItem = State(initialValue: groceryItem)
            _itemName = State(initialValue: groceryItem.itemName ?? "")
            _itemAmount = State(initialValue: groceryItem.amount )
            _itemCategory = State(initialValue: groceryItem.category ?? "")
        }
        else {
            _itemName = State(initialValue: "")
            _itemAmount = State(initialValue: 1)
            _itemCategory = State(initialValue: "")
        }
    }
    var body: some View {
        Form {
            Section(header: Text("Item Name")) {
                TextField("", text: $itemName )
            }
            Section(header: Text("Item Amoun")) {
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
                // Only allows number input
                    .onChange(of: amount) { oldValue, newValue in
                        amount = newValue.filter { "0123456789".contains($0)
                        }
                    }

                TextField("Category", text: $itemCategory)
                Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Measurment")) {
                    /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                }
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
            itemAmount = (amount as NSString).doubleValue
            selectedGroceryItem?.amount = itemAmount
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
        
        let context = Persistence.preview.container.viewContext
        let sampleItem = GroceryItem(context: context)

        return GroceryEditView(passedGroceryItem: sampleItem)
            .environment(\.managedObjectContext, context)
    }
}

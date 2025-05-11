import SwiftUI

struct GroceryEditView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedGroceryItem: GroceryItem?
    @State var itemName: String
    @State private var amount = ""
    @State private var itemCategory = ""
    @State private var itemMeasurment: MeasurementOptions = .none

    @Binding var selectedList : GroceryList?
    
    init(passedGroceryItem: GroceryItem?, passedList: Binding<GroceryList?>) {
        
        if let groceryItem = passedGroceryItem {
            _selectedGroceryItem = State(initialValue: groceryItem)
            _itemName = State(initialValue: groceryItem.itemName ?? "")
            _amount = State(initialValue: groceryItem.iamount ?? "")
            _itemCategory = State(initialValue: groceryItem.category ?? "")
            _itemMeasurment = State(initialValue: MeasurementOptions(rawValue: groceryItem.measurment ?? "") ?? .none)
        }
        else {
            _itemName = State(initialValue: "")
            _amount = State(initialValue: "")
            _itemCategory = State(initialValue: "")
            _itemMeasurment = State(initialValue: MeasurementOptions(rawValue: "") ??  .none)
        }
        self._selectedList = passedList
    }
    var body: some View {
        Form {
            Section(header: Text("Item Name")) {
                TextField("", text: $itemName ) {
                    
                }
            }
            HStack {
                Text("Category:")
                TextField("", text: $itemCategory)
            }
            HStack {
                Text("Amount:")
                TextField("", text: $amount)
                    .keyboardType(.numberPad)
                // Only allows number input
                    .onChange(of: amount) { oldValue, newValue in
                        amount = newValue.filter { "0123456789".contains($0)
                        }
                    }
            }
                Picker("Measurment:", selection: $itemMeasurment) {
                    ForEach(MeasurementOptions.allCases, id: \.self) {option in
                        Text(option.rawValue)
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
            selectedGroceryItem?.iamount = amount
            selectedGroceryItem?.itemName = itemName
            selectedGroceryItem?.category = itemCategory
            selectedGroceryItem?.measurment = itemMeasurment.rawValue
            
            if let groceryList = selectedList {
                groceryList.addToItems(selectedGroceryItem!)
            }
            
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

   //     return GroceryEditView(passedGroceryItem: sampleItem)
          //  .environment(\.managedObjectContext, context)
    }
}

import SwiftUI

struct GroceryEditView: View {
    
   
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    @State var selectedGroceryItem: GroceryItem?
    @State var itemName: String
    @State private var amount = ""
    @State private var itemMeasurment: MeasurementOptions = .none
    @ObservedObject var viewModel: GroceryListViewModel
    private var selectedList: GroceryList? {
        viewModel.selectedGroceryList
    }
    
    @FetchRequest(
            entity: SavedSettings.entity(),
            sortDescriptors: []
    ) private var entities: FetchedResults<SavedSettings>
    
    @State var selectedCategory: String = ""

    
    init(passedGroceryItem: GroceryItem?, viewModel: GroceryListViewModel) {
        self.viewModel = viewModel
        if let groceryItem = passedGroceryItem {
            _selectedGroceryItem = State(initialValue: groceryItem)
            _itemName = State(initialValue: groceryItem.itemName ?? "")
            _amount = State(initialValue: groceryItem.iamount ?? "")
            _selectedCategory = State(initialValue: groceryItem.category ?? "")
            _itemMeasurment = State(initialValue: MeasurementOptions(rawValue: groceryItem.measurment ?? "") ?? .none)
            
        }
        else {
            _itemName = State(initialValue: "")
            _amount = State(initialValue: "")
            _selectedCategory = State(initialValue: "")
            _itemMeasurment = State(initialValue: MeasurementOptions(rawValue: "") ??  .none)
        }
       
    }
    var body: some View {
        Form {
            Section(header: Text("Item Name")) {
                TextField("", text: $itemName ) {
                    
                }
            }
            Picker("Catergory:", selection: $selectedCategory) {
                var savedCategoryNames = entities.compactMap { $0.infos }.flatMap { $0 }
                ForEach(savedCategoryNames, id: \.self) { cat in
                    Text(cat)
                }
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

            // If there's no grocery item selected a new one is created
            if selectedGroceryItem == nil {
                selectedGroceryItem = GroceryItem(context: viewContext)
            }

            // Updates the properties of the grocery item using the values from UI
            selectedGroceryItem?.iamount = amount
            selectedGroceryItem?.itemName = itemName
            selectedGroceryItem?.category = selectedCategory
            selectedGroceryItem?.measurment = itemMeasurment.rawValue

            // If a grocery list is currently selected, adds this grocery item
            // to its collection of items
            if let groceryList = selectedList {
                groceryList.addToItems(selectedGroceryItem!)
            }

            // Dismiss the current view
            self.presentationMode.wrappedValue.dismiss()

            // Try to save the changes to the persistent store
            //If saving fails log the error and stop execution; this helps catch issues during development
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error (nsError) (nsError.userInfo)")
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

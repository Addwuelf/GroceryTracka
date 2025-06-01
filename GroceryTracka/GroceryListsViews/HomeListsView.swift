
import SwiftUI
import CoreData

// handles passing of selectedGroceryList
class GroceryListViewModel: ObservableObject {
    @Published var selectedGroceryList: GroceryList?
}

struct HomeListsView: View {
    
    @StateObject private var viewModel = GroceryListViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        entity: GroceryList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GroceryList.listname, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<GroceryList>
    
    @State private var listName = ""
    @State private var newListName = ""
    @State private var showingAlert = false
    @State private var showingEditAlert = false
    @State var titleText = "GroceryTracka"
    
    
    var body: some View {
        VStack(spacing: 0) {
            Text(titleText).font(.largeTitle) .onAppear {titleText = "GroceryTracka" }
            NavigationStack() {
                ZStack{
                    VStack {
                        List {
                            ForEach(lists) { list in
                                
                                HStack {
                                   
                                    // Contentviews View Triggered by Clicking the Text
                                    NavigationLink(
                                        destination: Contetview(viewModel: viewModel)
                                            .onAppear {
                                                viewModel.selectedGroceryList = list
                                                titleText = list.listname ?? "Grocery List"
                                            }
                                            .onDisappear { titleText = "GroceryTracka"}
                                    ) {
                                        Text(list.listname ?? "default value")
                                            .contentShape(Rectangle())
                                    }
                                    
                                    
                       
                                    
                                    
                                 // Displays alert
                                    Button(action: {
                                        showingEditAlert = true
                                        newListName = list.listname ?? "New List"
                                        viewModel.selectedGroceryList = list
                                        
                                    }) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                    .buttonStyle(BorderedButtonStyle())
                                    .alert("List Name", isPresented: $showingEditAlert) {
                                        
                                        VStack {
                                            TextField("", text: $newListName)
                                                .onChange(of: newListName) {
                                                    showingEditAlert.toggle()
                                                    showingEditAlert.toggle()
                                                }
                                        }
                                        Button("Ok", role: .cancel) {
                                            listName = newListName
                                            showingAlert = false
                                            let trimmedName = newListName.trimmingCharacters(in: .whitespacesAndNewlines)
                                            if(trimmedName.description.isEmpty) {
                                                newListName = "List"
                                                listName = newListName
                                        }
                                            addAction()
                                        }
                                    }
                                }
                            }
                            .onDelete(perform: deleteItem)
                            
                        }
                    }
                    
                    .toolbar() {
                        // Allows user to delete items
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        // When clicked displays a alert
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(" + "){
                                showingAlert = true
                            }
                            .font(.headline)
                           // Alert allows user to create a new Grocery List
                            .alert("Enter List Name", isPresented: $showingAlert) {
                                
                                VStack {
                                    TextField("", text: $newListName)
                                }
                                Button("Ok", role: .cancel) {
                                    listName = newListName
                                    showingAlert = false
                                    viewModel.selectedGroceryList = nil
                                    let trimmedName = newListName.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if(trimmedName.description.isEmpty) {
                                        newListName = "List"
                                        listName = newListName
                                }
                                    addAction()
                                }
                                
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
        }
    }
    
    // Allow deletion of a Grocery List
    func deleteItem(at offsetss: IndexSet) {
        offsetss.map {lists[$0]}.forEach(viewContext.delete)
        
        saveContext(viewContext)
        
    }
    
    func addAction() {
        withAnimation {
            if let list = viewModel.selectedGroceryList {
                    // If there's an existing list, updates its name instead of creating a new one
                    list.listname = newListName
                } else {
                    // If no list is selected, creates a new one
                    viewModel.selectedGroceryList = GroceryList(context: viewContext)
                    viewModel.selectedGroceryList?.listname = newListName
                }
            newListName = ""
            do {
                // Trys to save the changes
                try viewContext.save()
            } catch {
                // Display errors
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
            }
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext ) {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError) \(nsError.userInfo)")
        }
    }
}
#Preview {
    HomeListsView()
}

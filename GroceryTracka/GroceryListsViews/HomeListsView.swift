//
//  HomeListsView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 5/8/25.
//

import SwiftUI
import CoreData

struct HomeListsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        entity: GroceryList.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \GroceryList.listname, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<GroceryList>
    
    
    @State var selectedGroceryList: GroceryList?
    @State private var listName = ""
    @State private var newListName = ""
    @State private var showingAlert = false
    @State private var showingEditAlert = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            Text("GroceryTracka").font(.largeTitle)
            NavigationStack() {
                ZStack{
                    VStack {
                        List {
                            ForEach(lists) { list in
                                
                                HStack {
                                    // Contentviews View Triggered by Clicking the Text
                                    NavigationLink(destination: Contetview()) {
                                        Text(list.listname ?? "default value")
                                            .contentShape(Rectangle())
                                    }
                                    // Recipe View Triggered by Clicking the Info Icon
                                    Button(action: {
                                        showingEditAlert = true
                                        newListName = list.listname ?? "New List"
                                        selectedGroceryList = list
                                        
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
                                    selectedGroceryList = nil
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
            if let list = selectedGroceryList {
                    // If there's an existing list, updates its name instead of creating a new one
                    list.listname = newListName
                } else {
                    // If no list is selected, creates a new one
                    selectedGroceryList = GroceryList(context: viewContext)
                    selectedGroceryList?.listname = newListName
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

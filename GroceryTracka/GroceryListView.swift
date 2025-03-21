//
//  GroceryListView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/19/25.
//

import SwiftUI

struct GroceryListView: View {
    
    // Grocery Items Placeholder
    @State var groceryItems = ["Chicken", "Milk", "Banana"]
    @State var showAddItemOverlay = false
    @State var newItemName = ""
    
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    
                    List {
                        ForEach(groceryItems, id: \.self) { item in
                            Text(item)
                        }
                        .onDelete(perform: deleteItem)
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton()
                        }
                        ToolbarItem {
                            
                            // Lets user add item
                            Button(action: addItem) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                    }
                }
                .navigationTitle("Grocery List")
                
                if showAddItemOverlay {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showAddItemOverlay = false
                        }
                    
                    VStack(spacing: 20) {
                        Text("Add New Item")
                            .font(.headline)
                        
                        TextField("Enter Item Name", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        HStack {
                            Button("Cancel") {
                                showAddItemOverlay = false
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Button("Add"){
                                if !newItemName.isEmpty {
                                    groceryItems.append(newItemName)
                                    newItemName = ""
                                    showAddItemOverlay = false
                                }
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    
                }
            }
        }
    }
    
    func deleteItem(at offsetss: IndexSet) {
        groceryItems.remove(atOffsets: offsetss)
    }
    
    func addItem() {
        showAddItemOverlay = true
    }
    
}

#Preview {
    GroceryListView()
}

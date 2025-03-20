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
    
    var body: some View {
        List {
            ForEach(groceryItems, id: \.self) { item in
                Text(item)
            }
            .onDelete(perform: deleteItem)
        }
        .navigationTitle("Grocery List")

    }
    
    func deleteItem(at offsetss: IndexSet) {
        groceryItems.remove(atOffsets: offsetss)
    }
    
}

#Preview {
    GroceryListView()
}

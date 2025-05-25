//
//  ContentView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/19/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GroceryItem.itemName, ascending: true)],
        animation: .default)
    private var items: FetchedResults<GroceryItem>

    var body: some View {
        NavigationView {
           HomeListsView()
        }
    }



    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, Persistence.preview.container.viewContext)
}

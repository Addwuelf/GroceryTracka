//
//  FloatingButton.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import SwiftUI

struct FloatingButton: View {
    var body: some View {
        Spacer()
        HStack
        {
            NavigationLink(destination: GroceryEditView(passedGroceryItem: nil)){
                Text("+ New Item")
                    .font(.headline)
            }
            .padding(15)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(30)
            .padding(30)
            .shadow(color: .black.opacity(0.3), radius: 3, x: 3, y:3)
        }
    }
}

#Preview {
    FloatingButton()
}

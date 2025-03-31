//
//  RecipeListView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import SwiftUI

struct RecipeListView: View {
    
    var ingredients: String
    @State private var recipes: [Recipe] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading recipes...")
            }
            else {
                List(recipes, id: \.idmeal) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        Text(recipe.strMeal)
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeListView(ingredients: String)
}

//
//  RecipeListView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import SwiftUI

struct RecipeListView: View {

    var ingredient: String // The ingredient for which recipes will be fetched
    @State private var recipes: [Recipe] = [] // State variable to store the fetched recipes
    @State private var isLoading = true // State variable to indicate whether data is being loaded

    var body: some View {
        VStack {
            // Check if data is still loading
            if isLoading {
                ProgressView("Loading recipes...")
                // Data has finished loading
            } else {
                List(recipes, id: \.idMeal) { recipe in // Creates a list of recipes
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) { // Navigate to the recipe detail view when clicked
                        Text(recipe.strMeal)
                    }
                }
            }
        }
        .navigationTitle("(ingredient.capitalized) Recipes")
        .onAppear { // Fetch recipes when the view appears
            fetchRecipes(for: ingredient)
        }
    }
    
    // Function to fetch recipes for the given ingredient
    func fetchRecipes(for ingredient: String) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?i=\(ingredient)")
        else {return}

        URLSession.shared.dataTask(with: url) { data, response, error in // Creates a data task to fetch data from the API
            guard let data = data, error == nil else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data) // Decodes the JSON response
                DispatchQueue.main.async {
                    recipes = decodedResponse.meals
                    isLoading = false // Update the loading state
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }.resume() // Starts the data task
    }
}


// Struct for single Recipe
struct Recipe: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

// Array struct
struct RecipeResponse: Codable {
    let meals: [Recipe]
}

#Preview {
    RecipeListView(ingredient: "Chicken") 
}

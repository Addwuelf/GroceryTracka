

import SwiftUI

struct RecipeListView: View {
    
   @Binding var ingredient: String // Ingredient used for fetching recipes
    @State private var recipes: [Recipe] = [] // Stores fetched recipes
    @State private var isLoading = true // Indicates data loading state
    @ObservedObject var viewModel: GroceryListViewModel
    private var selectedList: GroceryList? {
        viewModel.selectedGroceryList
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading recipes...")
            } else {
                List(recipes, id: \.idMeal) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe, viewModel: viewModel, ingredientPicked: $ingredient)) {
                        Text(recipe.strMeal)
                    }
                }
            }
        }
        .navigationTitle("\(ingredient.capitalized) Recipes")
        .onAppear {
            fetchRecipes(for: ingredient)
        }
    }

    func fetchRecipes(for ingredient: String) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?i=\(ingredient)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeResponse.self, from: data)
                DispatchQueue.main.async {
                    recipes = decodedResponse.meals
                    isLoading = false
                }
            } catch {
                print("Error decoding response: (error)")
            }
        }.resume()
    }
}

// Struct for recipe list response
struct RecipeResponse: Codable {
    let meals: [Recipe]
}

// Struct representing a single recipe
struct Recipe: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

#Preview {
 
}

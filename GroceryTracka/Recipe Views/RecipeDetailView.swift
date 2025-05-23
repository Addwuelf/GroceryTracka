//
//  RecipeDetailView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: GroceryListViewModel

    @State private var ingredients: [(String, String)] = []
    @State private var instructions: String = ""
    @State private var isLoading = true
    @State private var selectedIngredient: GroceryItem?
    @State private var showingEditView = false

    var body: some View {
        VStack {
            Text(recipe.strMeal)
                .font(.largeTitle)
                .padding()
            
            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 300, height: 300)
            
            // Ingredients List
            List(ingredients, id: \.0) { ingredient, measure in
                Button(action: { openGroceryEditView(ingredient: ingredient, measurement: measure) }) {
                    HStack {
                        Text(ingredient)
                        Spacer()
                        Text(measure) // Show ingredient amount
                    }
                }
            }
            
            ScrollView{
            // Collapsible Instructions Section
            DisclosureGroup("Instructions") {
                Text(instructions)
                    .padding()
            }
            .padding()
        }

            Spacer()
        }
        .onAppear {
            fetchRecipeDetails(for: recipe.idMeal)
        }
        .navigationDestination(isPresented: $showingEditView) {
            GroceryEditView(passedGroceryItem: selectedIngredient, viewModel: viewModel)
        }
    }

    // Fetch full recipe details
    func fetchRecipeDetails(for id: String) {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeDetailResponse.self, from: data)
                DispatchQueue.main.async {
                    let details = decodedResponse.meals.first
                    ingredients = extractIngredients(from: details)
                    instructions = details?.strInstructions ?? "No instructions available."
                    isLoading = false
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }.resume()
    }

    // Extract ingredients dynamically
    func extractIngredients(from recipe: RecipeDetail?) -> [(String, String)] {
        guard let recipe = recipe else { return [] }

        let ingredientList: [(String?, String?)] = [
            (recipe.strIngredient1, recipe.strMeasure1),
            (recipe.strIngredient2, recipe.strMeasure2),
            (recipe.strIngredient3, recipe.strMeasure3),
            (recipe.strIngredient4, recipe.strMeasure4),
            (recipe.strIngredient5, recipe.strMeasure5),
            (recipe.strIngredient6, recipe.strMeasure6),
            (recipe.strIngredient7, recipe.strMeasure7),
            (recipe.strIngredient8, recipe.strMeasure8),
            (recipe.strIngredient9, recipe.strMeasure9),
            (recipe.strIngredient10, recipe.strMeasure10),
            (recipe.strIngredient11, recipe.strMeasure11),
            (recipe.strIngredient12, recipe.strMeasure12),
            (recipe.strIngredient13, recipe.strMeasure13),
            (recipe.strIngredient14, recipe.strMeasure14),
            (recipe.strIngredient15, recipe.strMeasure15),
            (recipe.strIngredient16, recipe.strMeasure16),
            (recipe.strIngredient17, recipe.strMeasure17),
            (recipe.strIngredient18, recipe.strMeasure18),
            (recipe.strIngredient19, recipe.strMeasure19),
            (recipe.strIngredient20, recipe.strMeasure20)
        ]

        return ingredientList.compactMap { ingredient, measure in
            guard let ingredient = ingredient, !ingredient.isEmpty,
                  let measure = measure, !measure.isEmpty else { return nil }
            return (ingredient, measure)
        }
    }

    // Navigate to GroceryEditView with selected ingredient
    func openGroceryEditView(ingredient: String, measurement: String) {
        let newItem = GroceryItem(context: viewContext)

        let (amount, measurementType) = parseMeasurement(from: measurement)
        newItem.itemName = ingredient
        newItem.iamount = amount
        newItem.measurment = measurementType

        selectedIngredient = newItem
        showingEditView = true
    }
    
    func parseMeasurement(from measurement: String) -> (String, String) {
        // Separate number & measurement type using regex
        let components = measurement.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)

        let amount = components.first ?? "Unknown"
        let typeString = components.count > 1 ? String(components[1]) : "Unknown"
        
        // Remove trailing white space
        let trimmedString = typeString.trimmingCharacters(in: .whitespacesAndNewlines)
        var measurementType: String
        // Convert measurement type to enum defaulting to .unknown if not found
        let matches = MeasurementOptions.allCases.filter { $0.rawValue == trimmedString }

        if let match = matches.first {
            measurementType = match.rawValue 
        } else {
            measurementType = "unknown"
        }

        return (String(amount), measurementType)
    }
}

// Struct for full recipe details
struct RecipeDetailResponse: Codable {
    let meals: [RecipeDetail]
}

// Struct for recipe details including ingredients & instructions
struct RecipeDetail: Codable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let strInstructions: String

    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?

    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
}

#Preview {
 
}

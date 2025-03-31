//
//  RecipeDetailView.swift
//  GroceryTracka
//
//  Created by Adam Wuelfing on 3/22/25.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe // The recipe to display in the view.

    var body: some View {
        VStack {
            // Displays the name of the recipe
            Text(recipe.strMeal)
                .font(.largeTitle)
                .padding() // Adds spacing around the text

            // Displays the recipe's thumbnail image
            AsyncImage(url: URL(string: recipe.strMealThumb)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                // Shows a loading indicator while the image is being loaded.
                ProgressView()
            }
            .frame(width: 300, height: 300)

            Spacer() // Adds space between the image and the bottom of the view.
        }
        .navigationTitle("Recipe Details")
    }
}

#Preview {
    RecipeDetailView(
        recipe: Recipe(
            idMeal: "12345",
            strMeal: "Chicken", // Sample recipe name for preview.
            strMealThumb: "https://www.themealdb.com/images/media/meals/llcbn01544231679.jpg" // Placeholder image URL.
        )
    )
}

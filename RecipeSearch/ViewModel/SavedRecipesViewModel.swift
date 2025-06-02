import Foundation
import SwiftData

struct SavedRecipesViewModel {
    func mapRecipeFromSavedRecipe(_ savedRecipe: SavedRecipe) -> Recipe {
        Recipe(
            id: savedRecipe.id,
            name: savedRecipe.name,
            source: savedRecipe.source,
            cuisines: savedRecipe.cuisines,
            imageUrl: savedRecipe.imageUrl,
            url: savedRecipe.url,
            isFavorite: true
        )
    }

    func delete(from savedRecipes: [SavedRecipe], in offsets: IndexSet, using modelContext: ModelContextProtocol) {
        for index in offsets {
            let recipe = savedRecipes[index]
            modelContext.delete(recipe)
        }
        try? modelContext.save()
    }
}

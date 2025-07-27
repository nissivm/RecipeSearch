import SwiftUI

struct ScreenAssembler {
    @ViewBuilder
    static func initialView() -> some View {
        InitialView(viewModel: InitialViewModel())
    }

    @ViewBuilder
    static func searchedRecipesView(using data: SearchData) -> some View {
        SearchedRecipesView(
            viewModel: SearchedRecipesViewModel(
                searchData: data,
                apiClient: APIClient()
            )
        )
    }

    @ViewBuilder
    static func savedRecipesView() -> some View {
        SavedRecipesView(viewModel: SavedRecipesViewModel())
    }

    @ViewBuilder
    static func recipeDetailView(using recipe: Recipe) -> some View {
        RecipeDetailView(recipe: recipe)
    }
}

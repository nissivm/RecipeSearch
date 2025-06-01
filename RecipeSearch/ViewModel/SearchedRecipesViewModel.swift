import SwiftUI
import SwiftData

enum SearchState {
    case loading
    case error
    case success
}

class SearchedRecipesViewModel: ObservableObject {
    private let searchData: SearchData
    private let apiClient: APIClientProtocol

    private var nextPage: URL?
    private var fetchingMore = false

    @Published private(set) var searchState: SearchState = .loading
    @Published private(set) var allRecipes: [Recipe] = []

    init(searchData: SearchData, apiClient: APIClientProtocol) {
        self.searchData = searchData
        self.apiClient = apiClient
    }

    @MainActor
    func fetchRecipes(checkSavedUsing savedRecipes: [SavedRecipe]) async {
        searchState = .loading
        let request = RecipeSearchRequest(ingredient: searchData.ingredient, cuisineType: searchData.cuisine)

        do {
            /// This part (before await) runs on MainActor.
            /// The 'await' call suspends execution and the network request
            /// will run on a background thread.
            let response = try await apiClient.execute(type: RecipeSearchModel.self, with: request)

            /// After 'await' completes, execution automatically hops back to MainActor.
            allRecipes = mapResponse(model: response, savedRecipes: savedRecipes)
            searchState = .success
        } catch {
            /// This also runs on MainActor after the catch block is entered.
            searchState = .error
        }
    }

    @MainActor
    func fetchMoreRecipes(_ recipe: Recipe, checkSavedUsing savedRecipes: [SavedRecipe]) async {
        guard let nextPage, isBottomRecipe(recipe), !fetchingMore else { return }

        fetchingMore = true

        do {
            let response = try await apiClient.executeNext(type: RecipeSearchModel.self, with: nextPage)
            let recipes = mapResponse(model: response, savedRecipes: savedRecipes)
            allRecipes.append(contentsOf: recipes)
            fetchingMore = false
        } catch {}
    }

    func manageRecipe(_ recipe: Recipe, using modelContext: ModelContext, and savedRecipes: [SavedRecipe]) {
        if !recipe.isFavorite {
            saveNewRecipe(recipe, using: modelContext)
        } else {
            deleteRecipe(recipe, using: modelContext, and: savedRecipes)
        }
    }
}

// MARK: - Private

private extension SearchedRecipesViewModel {
    func mapResponse(model: RecipeSearchModel, savedRecipes: [SavedRecipe]) -> [Recipe] {
        if let urlString = model.links?.next?.href {
            nextPage = URL(string: urlString)
        } else {
            nextPage = nil
        }

        return model.hits.map { hit in
            Recipe(
                id: hit.recipe.uri,
                name: hit.recipe.label,
                source: hit.recipe.source,
                cuisines: hit.recipe.cuisineType.joined(separator: ", "),
                imageUrl: URL(string: hit.recipe.images.regular.url),
                url: URL(string: hit.recipe.url),
                isFavorite: isSaved(recipeId: hit.recipe.uri, savedRecipes: savedRecipes)
            )
        }
    }

    func isBottomRecipe(_ recipe: Recipe) -> Bool {
        if let lastRecipe = allRecipes.last, lastRecipe.id == recipe.id {
            return true
        }
        return false
    }

    func isSaved(recipeId: String, savedRecipes: [SavedRecipe]) -> Bool {
        let saved = savedRecipes.filter { $0.id == recipeId }
        return saved.first != nil
    }

    func saveNewRecipe(_ recipe: Recipe, using modelContext: ModelContext) {
        recipe.isFavorite = true

        let newRecipe = SavedRecipe(
            id: recipe.id,
            name: recipe.name,
            source: recipe.source,
            cuisines: recipe.cuisines,
            imageUrl: recipe.imageUrl,
            url: recipe.url
        )

        modelContext.insert(newRecipe)
        try? modelContext.save()
    }

    func deleteRecipe(_ recipe: Recipe, using modelContext: ModelContext, and savedRecipes: [SavedRecipe]) {
        recipe.isFavorite = false

        let saved = savedRecipes.filter { $0.id == recipe.id }
        if let savedRecipe = saved.first {
            modelContext.delete(savedRecipe)
            try? modelContext.save()
        }
    }
}

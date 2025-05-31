import SwiftUI

enum SearchState {
    case loading
    case error
    case success([Recipe])
}

class SearchedRecipesViewModel: ObservableObject {
    private let searchData: SearchData
    private let apiClient: APIClientProtocol

    private var nextPage: URL?
    private var allRecipes: [Recipe] = []
    private var fetchingMore = false

    @Published var searchState: SearchState = .loading

    init(searchData: SearchData, apiClient: APIClientProtocol) {
        self.searchData = searchData
        self.apiClient = apiClient
    }

    @MainActor
    func fetchRecipes() async {
        searchState = .loading
        let request = RecipeSearchRequest(ingredient: searchData.ingredient, cuisineType: searchData.cuisine)

        do {
            /// This part (before await) runs on MainActor.
            /// The 'await' call suspends execution and the network request
            /// will run on a background thread.
            let response = try await apiClient.execute(type: RecipeSearchModel.self, with: request)

            /// After 'await' completes, execution automatically hops back to MainActor.
            allRecipes = mapResponse(model: response)
            searchState = .success(allRecipes)
        } catch {
            /// This also runs on MainActor after the catch block is entered.
            searchState = .error
        }
    }

    @MainActor
    func fetchMoreRecipes(_ recipe: Recipe) async {
        guard let nextPage, isBottomRecipe(recipe), !fetchingMore else { return }

        fetchingMore = true

        do {
            let response = try await apiClient.executeNext(type: RecipeSearchModel.self, with: nextPage)
            let recipes = mapResponse(model: response)
            allRecipes.append(contentsOf: recipes)
            searchState = .success(allRecipes)
            fetchingMore = false
        } catch {}
    }
}

private extension SearchedRecipesViewModel {
    func mapResponse(model: RecipeSearchModel) -> [Recipe] {
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
                isFavorite: false
            )
        }
    }

    func isBottomRecipe(_ recipe: Recipe) -> Bool {
        if let lastRecipe = allRecipes.last, lastRecipe.id == recipe.id {
            return true
        }
        return false
    }
}

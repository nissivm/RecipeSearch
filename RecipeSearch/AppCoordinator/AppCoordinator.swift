import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    static let shared = AppCoordinator()
    private init() {}

    func navigateToSearchedRecipes(using searchData: SearchData) {
        path.append(searchData)
    }

    func navigateToMyRecipes() {
        path.append("MyRecipesScreen")
    }

    func navigateToRecipeDetailView(using recipe: Recipe) {
        path.append(recipe)
    }
}

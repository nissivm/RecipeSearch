import Foundation

struct InitialViewModel {
    var cuisines: [String] {
        ["Any Cuisine", "American", "Asian", "British", "Caribbean",
         "Central Europe", "Chinese", "Eastern Europe",
         "French", "Greek", "Indian", "Italian", "Japanese",
         "Korean", "Kosher", "Mediterranean", "Mexican",
         "Middle Eastern", "Nordic", "South American",
         "South East Asian"]
    }

    var screenTitle: String {
        "Setup Search"
    }

    var searchRecipesButtonTitle: String {
        "Search Recipes"
    }

    var myRecipesButtonTitle: String {
        "MyRecipes"
    }

    var startSearchButtonTitle: String {
        "Start search!"
    }

    var textFieldPlaceholder: String {
        "Type in 1 ingredient"
    }

    var cuisinePickerTitle: String {
        "Select a cuisine"
    }

    func hasLetters(_ ingredient: String) -> Bool {
        ingredient.rangeOfCharacter(from: .letters) != nil
    }

    func searchDataCuisine(_ selectedCuisine: String) -> String {
        selectedCuisine == "Any Cuisine" ? "" : selectedCuisine
    }
}

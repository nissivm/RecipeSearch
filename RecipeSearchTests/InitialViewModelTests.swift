import Testing
@testable import RecipeSearch

struct InitialViewModelTests {
    private let sut = InitialViewModel()

    @Test
    func testCuisinesArray() {
        // Given
        let expectedCuisines = ["Any Cuisine", "American", "Asian", "British", "Caribbean",
                                "Central Europe", "Chinese", "Eastern Europe",
                                "French", "Greek", "Indian", "Italian", "Japanese",
                                "Korean", "Kosher", "Mediterranean", "Mexican",
                                "Middle Eastern", "Nordic", "South American",
                                "South East Asian"]

        // Then
        #expect(sut.cuisines == expectedCuisines)
        #expect(sut.cuisines.count == 21)
    }

    @Test
    func testScreenTitle() {
        #expect(sut.screenTitle == "Setup Search")
    }

    @Test
    func testSearchRecipesButtonTitle() {
        #expect(sut.searchRecipesButtonTitle == "Search Recipes")
    }

    @Test
    func testMyRecipesButtonTitle() {
        #expect(sut.myRecipesButtonTitle == "MyRecipes")
    }

    @Test
    func testStartSearchButtonTitle() {
        #expect(sut.startSearchButtonTitle == "Start search!")
    }

    @Test
    func testTextFieldPlaceholder() {
        #expect(sut.textFieldPlaceholder == "Type in 1 ingredient")
    }

    @Test
    func testCuisinePickerTitle() {
        #expect(sut.cuisinePickerTitle == "Select a cuisine")
    }

    @Test
    func testHasLettersWithLetters() {
        #expect(sut.hasLetters("apple"))
        #expect(sut.hasLetters("123abc"))
        #expect(sut.hasLetters("A"))
    }

    @Test
    func testHasLettersWithoutLetters() {
        #expect(!sut.hasLetters("123"))
        #expect(!sut.hasLetters("!@#$"))
        #expect(!sut.hasLetters(""))
    }

    @Test
    func testSearchDataCuisineAnyCuisine() {
        #expect(sut.searchDataCuisine("Any Cuisine") == "")
    }

    @Test
    func testSearchDataCuisineSpecificCuisine() {
        #expect(sut.searchDataCuisine("American") == "American")
        #expect(sut.searchDataCuisine("Italian") == "Italian")
    }
}

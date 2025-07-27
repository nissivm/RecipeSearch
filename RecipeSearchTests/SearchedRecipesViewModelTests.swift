import Foundation
import Testing
@testable import RecipeSearch

struct SearchedRecipesViewModelTests {
    private let searchData = SearchData(ingredient: "chicken", cuisine: "italian")
    private let mockAPIClient: MockAPIClient
    private let mockModelContext: MockModelContext
    private let sut: SearchedRecipesViewModel

    init() {
        mockAPIClient = MockAPIClient()
        mockModelContext = MockModelContext()

        sut = SearchedRecipesViewModel(
            searchData: searchData,
            apiClient: mockAPIClient
        )
    }

    @MainActor @Test
    func testFetchRecipesSuccess() async {
        // Given
        mockAPIClient.shouldThrowError = false
    
        // When
        await sut.fetchRecipes(checkSavedUsing: [])

        // Then
        #expect(sut.allRecipes.count == 6)
    }

    @MainActor @Test
    func testFetchRecipesFailure() async {
        // Given
        mockAPIClient.shouldThrowError = true
    
        // When
        await sut.fetchRecipes(checkSavedUsing: [])

        // Then
        #expect(sut.allRecipes.count == 0)
    }

    @MainActor @Test
    func testFetchMoreRecipesSuccess() async {
        // Given
        mockAPIClient.shouldThrowError = false
    
        // When
        await sut.fetchRecipes(checkSavedUsing: [])
        await sut.fetchMoreRecipes(fakeRecipe, checkSavedUsing: [])

        // Then
        #expect(sut.allRecipes.count == 12)
    }

    @MainActor @Test
    func testFetchMoreRecipesFailure() async {
        // Given
        mockAPIClient.shouldThrowError = false
        await sut.fetchRecipes(checkSavedUsing: [])
        mockAPIClient.shouldThrowError = true
    
        // When
        await sut.fetchMoreRecipes(fakeRecipe, checkSavedUsing: [])

        // Then
        #expect(sut.allRecipes.count == 6)
    }

    @Test
    func testManageRecipeInsert() {
        // When
        sut.manageRecipe(fakeRecipe, using: mockModelContext, and: [])

        // Then
        #expect(mockModelContext.insertCalled == true)
        #expect(mockModelContext.saveCalled == true)
    }

    @Test
    func testManageRecipeDelete() {
        // When
        sut.manageRecipe(fakeRecipe2, using: mockModelContext, and: [fakeSavedRecipe])

        // Then
        #expect(mockModelContext.deleteCalled == true)
        #expect(mockModelContext.saveCalled == true)
    }
}

private extension SearchedRecipesViewModelTests {
    var fakeRecipe: Recipe {
        Recipe(
            id: "abcd",
            name: "Chicken Tonnato",
            source: "Martha Stewart",
            cuisines: "japanese",
            imageUrl: URL(string: "https://example.com/image.jpg"),
            url: URL(string: "https://example.com/recipe"),
            isFavorite: false
        )
    }

    var fakeRecipe2: Recipe {
        Recipe(
            id: "abcd",
            name: "Chicken Tonnato",
            source: "Martha Stewart",
            cuisines: "japanese",
            imageUrl: URL(string: "https://example.com/image.jpg"),
            url: URL(string: "https://example.com/recipe"),
            isFavorite: true
        )
    }

    var fakeSavedRecipe: SavedRecipe {
        SavedRecipe(
            id: "abcd",
            name: "Chicken Tonnato",
            source: "Martha Stewart",
            cuisines: "japanese",
            imageUrl: URL(string: "https://example.com/saved_image.jpg"),
            url: URL(string: "https://example.com/saved_recipe")
        )
    }
}

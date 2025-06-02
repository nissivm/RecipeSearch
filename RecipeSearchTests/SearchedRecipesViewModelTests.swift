import XCTest
@testable import RecipeSearch

final class SearchedRecipesViewModelTests: XCTestCase {
    private let searchData = SearchData(ingredient: "chicken", cuisine: "italian")
    private var mockAPIClient: MockAPIClient!
    private var mockModelContext: MockModelContext!
    private var sut: SearchedRecipesViewModel!

    override func setUp() {
        super.setUp()
        mockAPIClient = MockAPIClient()
        mockModelContext = MockModelContext()

        sut = SearchedRecipesViewModel(
            searchData: searchData,
            apiClient: mockAPIClient
        )
    }

    override func tearDown() {
        super.tearDown()
        mockAPIClient = nil
        mockModelContext = nil
        sut = nil
    }
    
    @MainActor
    func test_fetchRecipes_success() async {
        // Given
        mockAPIClient.shouldThrowError = false
    
        // When
        await sut.fetchRecipes(checkSavedUsing: [])

        // Then
        XCTAssertEqual(sut.allRecipes.count, 6)
    }

    @MainActor
    func test_fetchRecipes_failure() async {
        // Given
        mockAPIClient.shouldThrowError = true
    
        // When
        await sut.fetchRecipes(checkSavedUsing: [])

        // Then
        XCTAssertEqual(sut.allRecipes.count, 0)
    }

    @MainActor
    func test_fetchMoreRecipes_success() async {
        // Given
        mockAPIClient.shouldThrowError = false
    
        // When
        await sut.fetchRecipes(checkSavedUsing: [])
        await sut.fetchMoreRecipes(fakeRecipe, checkSavedUsing: [])

        // Then
        XCTAssertEqual(sut.allRecipes.count, 12)
    }

    @MainActor
    func test_fetchMoreRecipes_failure() async {
        // Given
        mockAPIClient.shouldThrowError = false
        await sut.fetchRecipes(checkSavedUsing: [])
        mockAPIClient.shouldThrowError = true
    
        // When
        await sut.fetchMoreRecipes(fakeRecipe, checkSavedUsing: [])

        // Then
        XCTAssertEqual(sut.allRecipes.count, 6)
    }

    func test_manageRecipe_insert() {
        // When
        sut.manageRecipe(fakeRecipe, using: mockModelContext, and: [])

        // Then
        XCTAssertTrue(mockModelContext.insertCalled)
        XCTAssertTrue(mockModelContext.saveCalled)
    }

    func test_manageRecipe_delete() {
        // When
        sut.manageRecipe(fakeRecipe2, using: mockModelContext, and: [fakeSavedRecipe])

        // Then
        XCTAssertTrue(mockModelContext.deleteCalled)
        XCTAssertTrue(mockModelContext.saveCalled)
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

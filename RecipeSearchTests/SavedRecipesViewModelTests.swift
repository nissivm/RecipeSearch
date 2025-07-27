import Foundation
import Testing
@testable import RecipeSearch

struct SavedRecipesViewModelTests {
    private let sut = SavedRecipesViewModel()

    @Test
    func testScreenTitle() {
        #expect(sut.screenTitle == "My Recipes")
    }

    @Test
    func testErrorViewTitle() {
        #expect(sut.errorViewTitle == "You have no saved recipes, start adding some!")
    }

    @Test
    func testMapRecipeFromSavedRecipe() {
        // Given
        let savedRecipe = SavedRecipe(
            id: "1",
            name: "Test Saved Recipe",
            source: "Test Source",
            cuisines: "Test Cuisine",
            imageUrl: URL(string: "http://test.com/image.jpg"),
            url: URL(string: "http://test.com/recipe")
        )

        let expectedRecipe = Recipe(
            id: "1",
            name: "Test Saved Recipe",
            source: "Test Source",
            cuisines: "Test Cuisine",
            imageUrl: URL(string: "http://test.com/image.jpg"),
            url: URL(string: "http://test.com/recipe"),
            isFavorite: true
        )

        // When
        let mappedRecipe = sut.mapRecipeFromSavedRecipe(savedRecipe)

        // Then
        #expect(mappedRecipe == expectedRecipe)
    }

    @Test
    func testDeleteFunctionSuccess() {
        // Given
        let mockContext = MockModelContext()

        let recipe1 = SavedRecipe(id: "1", name: "Recipe 1", source: "S1", cuisines: "C1", imageUrl: nil, url: nil)
        let recipe2 = SavedRecipe(id: "2", name: "Recipe 2", source: "S2", cuisines: "C2", imageUrl: nil, url: nil)
        let recipe3 = SavedRecipe(id: "3", name: "Recipe 3", source: "S3", cuisines: "C3", imageUrl: nil, url: nil)

        let savedRecipes = [recipe1, recipe2, recipe3]
        let offsetsToDelete = IndexSet([1])

        // When
        sut.delete(from: savedRecipes, in: offsetsToDelete, using: mockContext)

        // Then
        #expect(mockContext.deletedObjects.count == 1)

        if let deleted = mockContext.deletedObjects.first as? SavedRecipe {
            #expect(deleted == recipe2)
        } else {
            Issue.record("Deleted object was not of type SavedRecipe or was nil.")
        }

        #expect(mockContext.saveCalled == true)
    }

    @Test
    func testDeleteFunctionMultipleDeletions() {
        // Given
        let mockContext = MockModelContext()

        let recipe1 = SavedRecipe(id: "1", name: "Recipe 1", source: "S1", cuisines: "C1", imageUrl: nil, url: nil)
        let recipe2 = SavedRecipe(id: "2", name: "Recipe 2", source: "S2", cuisines: "C2", imageUrl: nil, url: nil)
        let recipe3 = SavedRecipe(id: "3", name: "Recipe 3", source: "S3", cuisines: "C3", imageUrl: nil, url: nil)

        let savedRecipes = [recipe1, recipe2, recipe3]
        let offsetsToDelete = IndexSet([0, 2])

        // When
        sut.delete(from: savedRecipes, in: offsetsToDelete, using: mockContext)

        // Then
        #expect(mockContext.deletedObjects.count == 2)

        if let deleted1 = mockContext.deletedObjects.first as? SavedRecipe,
           let deleted2 = mockContext.deletedObjects.last as? SavedRecipe {
            #expect(deleted1 == recipe1)
            #expect(deleted2 == recipe3)
        } else {
            Issue.record("Deleted objects were not of type SavedRecipe or were nil.")
        }

        #expect(mockContext.saveCalled == true)
    }
}

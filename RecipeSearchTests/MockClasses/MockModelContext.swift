import SwiftData
@testable import RecipeSearch

class MockModelContext: ModelContextProtocol {
    var insertCalled = false
    var deleteCalled = false
    var deletedObjects: [any PersistentModel] = []
    var saveCalled = false

    func insert<T>(_ model: T) where T : PersistentModel {
        insertCalled = true
    }

    func delete<T>(_ model: T) where T : PersistentModel {
        deleteCalled = true
        deletedObjects.append(model)
    }

    func save() throws {
        saveCalled = true
    }
}

import SwiftData
@testable import RecipeSearch

class MockModelContext: ModelContextProtocol {
    var insertCalled = false
    var deleteCalled = false
    var saveCalled = false

    func insert<T>(_ model: T) where T : PersistentModel {
        insertCalled = true
    }
    
    func delete<T>(_ model: T) where T : PersistentModel {
        deleteCalled = true
    }
    
    func save() throws {
        saveCalled = true
    }
}

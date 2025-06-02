import SwiftData

protocol ModelContextProtocol {
    func insert<T>(_ model: T) where T : PersistentModel
    func delete<T>(_ model: T) where T : PersistentModel
    func save() throws
}

extension ModelContext: ModelContextProtocol {}

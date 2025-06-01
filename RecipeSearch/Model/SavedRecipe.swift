import Foundation
import SwiftData

@Model
final class SavedRecipe: Identifiable, Hashable {
    @Attribute(.unique) var id: String
    var name: String
    var source: String
    var cuisines: String
    var imageUrl: URL?
    var url: URL?

    init(id: String,
         name: String,
         source: String,
         cuisines: String,
         imageUrl: URL?,
         url: URL?) {
        self.id = id
        self.name = name
        self.source = source
        self.cuisines = cuisines
        self.imageUrl = imageUrl
        self.url = url
    }

    static func == (lhs: SavedRecipe, rhs: SavedRecipe) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

import Foundation

class Recipe: ObservableObject, Identifiable, Hashable {
    let id: String
    let name: String
    let source: String
    let cuisines: String
    let imageUrl: URL?
    let url: URL?
    @Published var isFavorite: Bool

    init(id: String,
         name: String,
         source: String,
         cuisines: String,
         imageUrl: URL?,
         url: URL?,
         isFavorite: Bool) {
        self.id = id
        self.name = name
        self.source = source
        self.cuisines = cuisines
        self.imageUrl = imageUrl
        self.url = url
        self.isFavorite = isFavorite
    }

    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

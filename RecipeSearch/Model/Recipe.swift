import Foundation

struct Recipe: Identifiable, Hashable {
    let id: String
    let name: String
    let source: String
    let cuisines: String
    let imageUrl: URL?
    let url: URL?
    let isFavorite: Bool
}

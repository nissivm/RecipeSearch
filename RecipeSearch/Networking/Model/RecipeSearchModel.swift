import Foundation

// MARK: - RecipeSearchModel

struct RecipeSearchModel: Codable {
    let from, to, count: Int
    let links: Links
    let hits: [Hit]

    enum CodingKeys: String, CodingKey {
        case from, to, count
        case links = "_links"
        case hits
    }
}

// MARK: - Hit

struct Hit: Codable {
    let recipe: Recipe

    enum CodingKeys: String, CodingKey {
        case recipe
    }
}

// MARK: - Links

struct Links: Codable {
    let next: Next

    enum CodingKeys: String, CodingKey {
        case next
    }
}

// MARK: - Next

struct Next: Codable {
    let href, title: String
}

// MARK: - Recipe

struct Recipe: Codable {
    let label: String
    let images: Images
    let source: String
    let url: String
    let cuisineType: [String]

    enum CodingKeys: String, CodingKey {
        case label, images, source, url, cuisineType
    }
}

// MARK: - Images

struct Images: Codable {
    let regular: RecipeImage

    enum CodingKeys: String, CodingKey {
        case regular = "REGULAR"
    }
}

// MARK: - RecipeImage

struct RecipeImage: Codable {
    let url: String
    let width, height: Int
}

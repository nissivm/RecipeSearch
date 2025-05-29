import Foundation

enum RecipeSearchError: Error {
    case invalidUrl
    case invalidRequest
    case jsonDecodingFailure
    case failStatusCode
}

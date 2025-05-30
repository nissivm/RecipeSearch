import Foundation

enum RecipeSearchError: Error {
    case invalidRequest
    case jsonDecodingFailure
    case failStatusCode
}

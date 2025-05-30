import Foundation

protocol APIClientProtocol {
    func execute<T: Decodable>(type: T.Type, with requestable: URLRequestable) async throws -> T
    func executeNext<T: Decodable>(type: T.Type, with url: URL) async throws -> T
}

struct APIClient: APIClientProtocol {
    func execute<T: Decodable>(type: T.Type, with requestable: URLRequestable) async throws -> T {
        guard let request = requestable.urlRequest else {
            throw RecipeSearchError.invalidRequest
        }
        return try await performRequest(type: type, with: request)
    }

    func executeNext<T: Decodable>(type: T.Type, with url: URL) async throws -> T {
        let request = URLRequest(url: url)
        return try await performRequest(type: type, with: request)
    }
}

private extension APIClient {
    func performRequest<T: Decodable>(type: T.Type, with request: URLRequest) async throws -> T {
        let session = URLSession(configuration: .default)
        let (data, response) = try await session.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw RecipeSearchError.failStatusCode
        }

        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            throw RecipeSearchError.jsonDecodingFailure
        }
    }
}

import Foundation

protocol URLRequestable {
    var urlRequest: URLRequest? { get }
}

struct RecipeSearchRequest: URLRequestable {
    private let url: URL?

    init(ingredient: String, cuisineType: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "/api/recipes/v2"

        components.queryItems = [
            URLQueryItem(name: "q", value: ingredient),
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "beta", value: "false"),
            URLQueryItem(name: "app_id", value: Configuration.appId),
            URLQueryItem(name: "app_key", value: Configuration.appKey)
        ]

        if !cuisineType.isEmpty {
            components.queryItems?.append(URLQueryItem(name: "cuisineType", value: cuisineType))
        }

        url = components.url
    }

    var urlRequest: URLRequest? {
        guard let url = url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}

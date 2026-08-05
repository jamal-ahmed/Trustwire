import Foundation

/// Pure function that turns an `APIEndpoint` into a `URLRequest`. Kept separate
/// from `URLSessionNetworkClient` so it can be unit tested without touching
/// the network.
enum RequestBuilder {
    static func build(
        endpoint: APIEndpoint,
        configuration: NetworkConfiguration
    ) throws -> URLRequest {
        guard var components = URLComponents(
            url: configuration.baseURL.appendingPathComponent(endpoint.path),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }

        if let queryItems = endpoint.queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: configuration.timeout)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Precedence: default headers < endpoint headers.
        var headers = configuration.defaultHeaders
        endpoint.headers?.forEach { headers[$0.key] = $0.value }
        request.allHTTPHeaderFields = headers

        return request
    }
}

import Foundation
@testable import Trustwire

struct TodoItem: Codable, Equatable, Sendable {
    let id: Int
    let title: String
}

struct GetTodoEndpoint: APIEndpoint {
    let id: Int
    var path: String { "/todos/\(id)" }
    var method: HTTPMethod { .get }
}

struct CreateTodoEndpoint: APIEndpoint {
    let title: String
    var path: String { "/todos" }
    var method: HTTPMethod { .post }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var body: Data? { try? Self.jsonBody(["title": title]) }
}

enum TestSupport {
    static func configuration(baseURL: String = "https://api.example.com") -> NetworkConfiguration {
        NetworkConfiguration(baseURL: URL(string: baseURL)!)
    }

    static func response(url: URL, statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

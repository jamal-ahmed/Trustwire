import Foundation

/// Standard HTTP methods supported by the client.
///
/// Introduced in v1 (basic REST support).
public enum HTTPMethod: String, Sendable, Equatable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

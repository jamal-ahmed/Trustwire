import Foundation

/// Describes a single REST call in a transport-agnostic way.
///
/// Conforming types only describe *what* to call; `NetworkClient` decides *how*
/// (base URL, transport) so endpoint definitions stay small and testable.
public protocol APIEndpoint: Sendable {
    /// Path relative to the client's base URL, e.g. `"/users/42"`.
    var path: String { get }

    var method: HTTPMethod { get }

    /// Endpoint-specific headers. Merged over the client's default headers.
    var headers: [String: String]? { get }

    var queryItems: [URLQueryItem]? { get }

    /// Pre-encoded request body. Use `JSONEncoder` in the call site or a helper
    /// to build this from a `Codable` value.
    var body: Data? { get }
}

// Sensible defaults so most endpoints only need to specify `path` and `method`.
public extension APIEndpoint {
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

public extension APIEndpoint {
    /// Convenience for building a JSON body from any `Encodable` value.
    static func jsonBody<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        try encoder.encode(value)
    }
}

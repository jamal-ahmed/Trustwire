import Foundation

/// Transport-agnostic interface for sending `APIEndpoint`s.
///
/// Depend on this protocol (not `URLSessionNetworkClient`) so call sites remain
/// testable via a fake/mock implementation.
public protocol NetworkClient: Sendable {
    /// Sends the endpoint and decodes the response body as `T`.
    func send<T: Decodable & Sendable>(_ endpoint: APIEndpoint, decodingTo type: T.Type) async throws -> T

    /// Sends the endpoint and returns the raw response body, for callers that
    /// don't need JSON decoding (e.g. file downloads, empty 204 responses).
    @discardableResult
    func send(_ endpoint: APIEndpoint) async throws -> Data
}

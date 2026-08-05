import Foundation

/// Errors that can be produced anywhere along the request/response pipeline.
public enum NetworkError: Error, Sendable, Equatable {
    /// The endpoint could not be turned into a valid `URL`.
    case invalidURL

    /// The underlying `URLSession` call failed (no connectivity, timeout, etc).
    case transportError(String)

    /// The response was not an `HTTPURLResponse`, which should never happen with URLSession/HTTP(S).
    case invalidResponse

    /// The server returned a non-2xx status code. `data` is included so callers can
    /// attempt to decode a server-provided error payload.
    case server(statusCode: Int, data: Data?)

    /// `JSONDecoder` (or a custom decoder) failed to decode the response body.
    case decodingFailed(String)

    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.invalidResponse, .invalidResponse):
            return true
        case let (.transportError(a), .transportError(b)):
            return a == b
        case let (.decodingFailed(a), .decodingFailed(b)):
            return a == b
        case let (.server(aCode, aData), .server(bCode, bData)):
            return aCode == bCode && aData == bData
        default:
            return false
        }
    }
}

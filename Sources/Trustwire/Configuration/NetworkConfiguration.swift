import Foundation

/// Everything a `URLSessionNetworkClient` needs to know about the environment
/// it's talking to. Build one per backend (e.g. "staging", "production").
public struct NetworkConfiguration: Sendable {
    public var baseURL: URL
    public var defaultHeaders: [String: String]
    public var timeout: TimeInterval
    public var decoder: JSONDecoder

    public init(
        baseURL: URL,
        defaultHeaders: [String: String] = ["Accept": "application/json"],
        timeout: TimeInterval = 30,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.timeout = timeout
        self.decoder = decoder
    }
}

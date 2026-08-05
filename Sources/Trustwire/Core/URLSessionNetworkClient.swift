import Foundation

/// `NetworkClient` implementation backed by `URLSession`. Handles basic REST
/// requests: URL/header/body construction, transport, status-code mapping,
/// and JSON decoding.
public final class URLSessionNetworkClient: NetworkClient {
    private let configuration: NetworkConfiguration
    private let session: URLSession

    /// - Parameters:
    ///   - configuration: Base URL, default headers, timeout, decoder.
    ///   - session: Inject a custom `URLSession` for testing (e.g. one configured
    ///     with `URLProtocol` mocking).
    public init(
        configuration: NetworkConfiguration,
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.session = session
    }

    public func send<T: Decodable & Sendable>(_ endpoint: APIEndpoint, decodingTo type: T.Type) async throws -> T {
        let data = try await send(endpoint)
        do {
            return try configuration.decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(String(describing: error))
        }
    }

    @discardableResult
    public func send(_ endpoint: APIEndpoint) async throws -> Data {
        let request = try RequestBuilder.build(endpoint: endpoint, configuration: configuration)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transportError(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200..<300:
            return data
        default:
            throw NetworkError.server(statusCode: httpResponse.statusCode, data: data)
        }
    }
}

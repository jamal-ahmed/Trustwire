import Testing
import Foundation
@testable import Trustwire

@Suite("URLSessionNetworkClient - basic REST", .serialized)
struct URLSessionNetworkClientTests {

    @Test("decodes a successful JSON response")
    func decodesSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            let body = try! JSONEncoder().encode(TodoItem(id: 7, title: "Buy milk"))
            return (TestSupport.response(url: request.url!, statusCode: 200), body)
        }

        let client = URLSessionNetworkClient(configuration: TestSupport.configuration(), session: .mocked())

        let todo = try await client.send(GetTodoEndpoint(id: 7), decodingTo: TodoItem.self)
        #expect(todo == TodoItem(id: 7, title: "Buy milk"))
    }

    @Test("maps non-2xx status codes to NetworkError.server")
    func mapsServerError() async throws {
        MockURLProtocol.requestHandler = { request in
            (TestSupport.response(url: request.url!, statusCode: 500), Data("oops".utf8))
        }

        let client = URLSessionNetworkClient(configuration: TestSupport.configuration(), session: .mocked())

        await #expect(throws: NetworkError.server(statusCode: 500, data: Data("oops".utf8))) {
            try await client.send(GetTodoEndpoint(id: 1), decodingTo: TodoItem.self)
        }
    }

    @Test("maps invalid JSON to NetworkError.decodingFailed")
    func mapsDecodingError() async throws {
        MockURLProtocol.requestHandler = { request in
            (TestSupport.response(url: request.url!, statusCode: 200), Data("not json".utf8))
        }

        let client = URLSessionNetworkClient(configuration: TestSupport.configuration(), session: .mocked())

        await #expect(throws: NetworkError.self) {
            try await client.send(GetTodoEndpoint(id: 1), decodingTo: TodoItem.self)
        }
    }
}

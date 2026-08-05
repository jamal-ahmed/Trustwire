import Testing
import Foundation
@testable import Trustwire

@Suite("RequestBuilder")
struct RequestBuilderTests {

    @Test("builds URL, method and default headers for a basic GET endpoint")
    func basicGetRequest() throws {
        let config = TestSupport.configuration()
        let request = try RequestBuilder.build(endpoint: GetTodoEndpoint(id: 7), configuration: config)

        #expect(request.url?.absoluteString == "https://api.example.com/todos/7")
        #expect(request.httpMethod == "GET")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test("attaches an encoded body and endpoint-specific headers on POST")
    func postRequestWithBody() throws {
        let config = TestSupport.configuration()
        let request = try RequestBuilder.build(endpoint: CreateTodoEndpoint(title: "Buy milk"), configuration: config)

        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        #expect(request.httpBody != nil)
    }

    @Test("endpoint headers take precedence over default headers")
    func headerPrecedence() throws {
        let config = NetworkConfiguration(
            baseURL: URL(string: "https://api.example.com")!,
            defaultHeaders: ["Accept": "text/plain"]
        )

        struct CustomAcceptEndpoint: APIEndpoint {
            var path: String { "/x" }
            var method: HTTPMethod { .get }
            var headers: [String: String]? { ["Accept": "application/json"] }
        }

        let request = try RequestBuilder.build(endpoint: CustomAcceptEndpoint(), configuration: config)
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test("appends query items when present")
    func queryItems() throws {
        struct SearchEndpoint: APIEndpoint {
            var path: String { "/search" }
            var method: HTTPMethod { .get }
            var queryItems: [URLQueryItem]? { [URLQueryItem(name: "q", value: "swift")] }
        }

        let request = try RequestBuilder.build(endpoint: SearchEndpoint(), configuration: TestSupport.configuration())
        #expect(request.url?.absoluteString == "https://api.example.com/search?q=swift")
    }
}

# Trustwire

# YourSwiftPackage

[![Swift CI](https://github.com/USERNAME/REPOSITORY/actions/workflows/swift.yml/badge.svg)](https://github.com/USERNAME/REPOSITORY/actions/workflows/swift.yml)
![Swift Version](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)
![Platforms](https://img.shields.io/badge/Platforms-macOS%20%7C%20iOS%20%7C%20tvOS%20%7C%20watchOS-blue)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A small, dependency-free Swift Package for making REST calls, built to be
dropped into any iOS/macOS project.

**This is v1: basic REST.** Private/authenticated endpoints and certificate
pinning land in later versions, additively — nothing here will need to
change when they do.

## Design

- **`APIEndpoint`** describes *what* to call (path, method, headers, body).
  It knows nothing about base URLs or transport.
- **`NetworkClient`** is the protocol call sites depend on, so tests can swap
  in a fake implementation instead of hitting the network.
- **`URLSessionNetworkClient`** is the concrete implementation: request
  building, transport, status-code mapping, JSON decoding.
- **`RequestBuilder`** is a pure function (`APIEndpoint` + `NetworkConfiguration`
  → `URLRequest`) so URL/header construction is unit-testable without mocking
  the network at all.

## Usage

```swift
struct GetTodo: APIEndpoint {
    let id: Int
    var path: String { "/todos/\(id)" }
    var method: HTTPMethod { .get }
}

let client = URLSessionNetworkClient(
    configuration: NetworkConfiguration(baseURL: URL(string: "https://api.example.com")!)
)

let todo = try await client.send(GetTodo(id: 7), decodingTo: Todo.self)
```

## Testing

Tests use the **Swift Testing** framework (`import Testing`, `@Test`, `#expect`).

- `RequestBuilderTests` — pure unit tests of URL/header/body construction, no
  networking involved.
- `URLSessionNetworkClientTests` — exercises the REST path against a
  `MockURLProtocol`-backed `URLSession`, so no real network calls happen.

Run tests:

```bash
swift test
```

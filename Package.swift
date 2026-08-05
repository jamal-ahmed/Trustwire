// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Trustwire",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "Trustwire",
            targets: ["Trustwire"]
        )
    ],
    targets: [
        .target(
            name: "Trustwire",
            path: "Sources/Trustwire"
        ),
        .testTarget(
            name: "TrustwireTests",
            dependencies: ["Trustwire"],
            path: "Tests/TrustwireTests"
        )
    ]
)

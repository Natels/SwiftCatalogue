// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftCatalogue",
    platforms: [
        .iOS(.v16),
        .macOS(.v14),
        .watchOS(.v8),
        .tvOS(.v15),
    ],
    products: [
        .library(
            name: "SwiftCatalogue",
            targets: ["SwiftCatalogue"]
        )
    ],
    targets: [
        .target(
            name: "SwiftCatalogue"),
        .testTarget(
            name: "SwiftCatalogueTests",
            dependencies: ["SwiftCatalogue"]
        ),
    ]
)

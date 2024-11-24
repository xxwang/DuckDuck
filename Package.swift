// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DuckDuck",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DuckDuck",
            targets: ["DuckDuck"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DuckDuck",
            dependencies: []
        ),
        .testTarget(
            name: "DuckDuckTests",
            dependencies: ["DuckDuck"]
        ),
    ]
)

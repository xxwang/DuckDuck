// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "DuckDuck",
    defaultLocalization: "zh-Hans",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DuckDuckSwift",
            targets: ["DuckDuckSwift"]
        ),
        .library(
            name: "DuckDuckCpp",
            targets: ["DuckDuckCpp"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DuckDuckSwift",
            dependencies: [
                "DuckDuckCpp",
            ],
            path: "DuckDuck-swift",
            swiftSettings: [.define("SPM_MODE")]
        ),
        .target(
            name: "DuckDuckCpp",
            dependencies: [
            ],
            path: "DuckDuck-cpp",
            publicHeadersPath: ""
        ),
    ],
//    swiftLanguageVersions: [.v5, .v6],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)

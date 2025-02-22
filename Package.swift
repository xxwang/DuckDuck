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
            name: "DuckDuck",
            targets: ["DuckDuck"]
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
            name: "DuckDuck",
            dependencies: [
                "DuckDuckCpp",
            ],
            path: "DuckDuck",
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

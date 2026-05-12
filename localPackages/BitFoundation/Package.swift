// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "BitFoundation",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BitFoundation",
            targets: ["BitFoundation"]
        ),
        .library(
            name: "BitFoundationTestHelpers",
            targets: ["BitFoundationTestHelpers"]
        )
    ],
    dependencies: [
        .package(path: "../BitLogger")
    ],
    targets: [
        .target(
            name: "BitFoundation",
            dependencies: [
                .product(name: "BitLogger", package: "BitLogger"),
            ],
            path: "Sources/BitFoundation"
        ),
        .target(
            name: "BitFoundationTestHelpers",
            dependencies: ["BitFoundation"],
            path: "Sources/BitFoundationTestHelpers"
        ),
        .testTarget(
            name: "BitFoundationTests",
            dependencies: ["BitFoundation", "BitFoundationTestHelpers"],
        )
    ]
)

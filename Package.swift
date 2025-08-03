// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ColorConverter",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ColorConverter",
            targets: ["ColorConverter"]),
    ],
    targets: [
        .target(
            name: "ColorConverter"),
        .testTarget(
            name: "ColorConverterTests",
            dependencies: ["ColorConverter"]),
    ]
)

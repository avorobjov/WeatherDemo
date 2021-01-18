// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    products: [
        .library(
            name: "Services",
            targets: ["Services"]),
    ],
    dependencies: [
        .package(path: "../Entities")
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: ["Entities"]),
        .testTarget(
            name: "ServicesTests",
            dependencies: ["Services", "Entities"],
            resources: [.process("Data")]),
    ]
)

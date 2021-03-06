// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "appstoreconnect"
let package = Package(
    name: name,
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: name, targets: [name])
    ],
    dependencies: [
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: name,
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "JWTKit", package: "jwt-kit")
            ]
        ),
        .testTarget(
            name: "\(name)Tests",
            dependencies: ["appstoreconnect"]
        )
    ]
)

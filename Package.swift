// swift-tools-version:5.10
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
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "1.5.0")),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.13.4")
    ],
    targets: [
        .executableTarget(
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

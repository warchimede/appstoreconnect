// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let name = "appstoreconnect" 
let package = Package(
    name: name,
    products: [
        .executable(name: name, targets: [name])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0"))
    ],
    targets: [
        .target(
            name: name,
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .testTarget(
            name: "\(name)Tests",
            dependencies: ["appstoreconnect"])
    ]
)

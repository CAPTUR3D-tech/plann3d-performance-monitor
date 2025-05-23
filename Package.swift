// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Plann3dPerformanceMonitor",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Plann3dPerformanceMonitor",
            targets: ["Plann3dPerformanceMonitor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dani-gavrilov/GDPerformanceView-Swift.git", from: "2.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Plann3dPerformanceMonitor",
            dependencies: ["GDPerformanceView-Swift"]),

    ]
)

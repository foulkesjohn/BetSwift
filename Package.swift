// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "BetSwift",
  products: [
    .library(name: "BetSwift",
             targets: ["BetSwift"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/apple/swift-nio-ssl.git", .upToNextMajor(from: "2.0.0")),
    .package(url: "https://github.com/vapor-community/clibressl.git", from: "1.0.0"),
  ],
  targets: [
    .target(name: "BetSwift",
            dependencies: ["NIO",
                           "NIOHTTP1",
                           "NIOFoundationCompat",
                           "NIOSSL",
                           "CLibreSSL"]),
    .testTarget(name: "BetSwiftTests", dependencies: ["BetSwift"])
  ])

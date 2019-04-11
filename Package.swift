// swift-tools-version:5.0
import PackageDescription

let package = Package(name: "BetSwift",
  products: [
    .library(name: "BetSwift",
             targets: ["BetSwift"])
  ],
  dependencies: [
    .package(url: "https://github.com/foulkesjohn/Kitura-net.git", .branch("master")),
    .package(url: "https://github.com/apple/swift-nio.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "1.0.0"),
    .package(url: "https://github.com/vapor-community/clibressl.git", from: "1.0.0"),
    .package(url: "https://github.com/foulkesjohn/tracelog.git", from: "4.0.2"),
  ],
  targets: [
    .target(name: "BetSwift",
            dependencies: ["KituraNet",
                           "NIO",
                           "NIOOpenSSL",
                           "CLibreSSL",
                           "TraceLog"]),
    .testTarget(name: "BetSwiftTests", dependencies: ["BetSwift"])
  ])

// swift-tools-version:4.0
import PackageDescription

let package = Package(name: "BetSwift",
  products: [
    .library(name: "BetSwift",
             targets: ["BetSwift"])
  ],
  dependencies: [
    .package(url: "https://github.com/IBM-Swift/BlueSocket.git", from: "0.12.76"),
    .package(url: "https://github.com/IBM-Swift/BlueSSLService.git", from: "0.12.64"),
    .package(url: "https://github.com/emiliopavia/Kitura-net.git", .branch("master")),
    .package(url: "https://github.com/apple/swift-nio.git", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-nio-ssl.git", from: "1.0.0"),
    .package(url: "https://github.com/vapor-community/clibressl.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "BetSwift",
            dependencies: ["Socket",
                           "SSLService",
                           "Kitura-net",
                           "NIO",
                           "NIOOpenSSL",
                           "CLibreSSL"]),
    .testTarget(name: "BetSwiftTests", dependencies: ["BetSwift"])
  ])

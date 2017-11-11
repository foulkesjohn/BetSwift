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
    .package(url: "https://github.com/emiliopavia/Kitura-net.git", .branch("master"))
  ],
  targets: [
    .target(name: "BetSwift",
            dependencies: ["Socket",
                           "SSLService",
                           "Kitura-net"]),
    .testTarget(name: "BetSwiftTests", dependencies: ["BetSwift"])
  ])

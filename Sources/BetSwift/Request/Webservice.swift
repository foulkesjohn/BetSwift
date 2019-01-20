import Foundation
import NIO
import TraceLog

struct BetfairError: Codable {
  let faultcode: String?
  let faultstring: String?
  let jsonrpc: String?
  let code: Int?
  let error: Error?
  let message: String?
  let detail: [String: String]?
  struct Error: Codable {
    let code: Int
    let message: String
  }
}

public final class Webservice {
  enum Error: Swift.Error {
    case unknown
    case betfair(BetfairError)
  }
  
  private let session: URLSession
  private let sessionToken: String
  private let appKey: String
  private let group: MultiThreadedEventLoopGroup
  
  public static var shared: Webservice!
  
  public init(session: URLSession = .shared,
              sessionToken: String,
              appKey: String,
              group: MultiThreadedEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)) {
    self.session = session
    self.sessionToken = sessionToken
    self.appKey = appKey
    self.group = group
  }
  
  public func load<A>(_ resource: Resource<A>) -> EventLoopFuture<A> {
    let loop = group.next()
    let promise: EventLoopPromise<A> = loop.newPromise()
    var request = URLRequest(url: resource.url)
    request.httpMethod = resource.method.method
    request.allHTTPHeaderFields = headers()
    logTrace("BetSwift", level: 1) {
      "Request: \(request)"
    }
    if case let .post(data) = resource.method {
      request.httpBody = data
      logTrace("BetSwift", level: 1) {
        let body = String(data: data, encoding: .utf8) ?? ""
        return "Request body: \(body)"
      }
    }
    self.session.dataTask(with: request) {
      data, response, error in
      guard let result = data.flatMap(resource.parse) else {
        if let data = data,
          let error = try? decoder.decode(BetfairError.self, from: data) {
          promise.fail(error: Error.betfair(error))
        } else {
          promise.fail(error: Error.unknown)
        }
        return
      }
      promise.succeed(result: result)
      }.resume()
    return promise.futureResult
  }
  
  public func headers() -> [String: String] {
    return ["X-Application": appKey,
            "X-Authentication": sessionToken,
            "Content-Type": "application/json",
            "Accept-Encoding": "gzip, deflate",
            "Connect": "keep-alive"]
  }
  
}

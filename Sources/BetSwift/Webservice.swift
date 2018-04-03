import Foundation
import NIO

public final class Webservice {
  enum Error: Swift.Error {
    case unknown
  }
  
  private let session: URLSession
  private let sessionToken: String
  private let appKey: String
  private let group: MultiThreadedEventLoopGroup
  
  public static var shared: Webservice!
  
  public init(session: URLSession = .shared,
              sessionToken: String,
              appKey: String,
              group: MultiThreadedEventLoopGroup = MultiThreadedEventLoopGroup(numThreads: 1)) {
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
    if case let .post(data) = resource.method {
      request.httpBody = data
    }
    self.session.dataTask(with: request) {
      data, _, error in
      guard let result = data.flatMap(resource.parse) else {
        promise.fail(error: error ?? Error.unknown)
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

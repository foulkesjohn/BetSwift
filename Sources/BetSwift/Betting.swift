import Foundation
import NIO

public enum ResourceError: Swift.Error {
  case encodingFailed
}

public extension EventLoop {
  
  public func resource<Input: Codable & EndpointType & ResourceType>(input: Input) -> EventLoopFuture<Input.ReturnType>? {
    guard let data = try? JSONEncoder().encode(input) else { return nil }
      let resource = Resource<Input.ReturnType>(url: input.url,
                                                method: HttpMethod.post(data))
    return Webservice.shared.load(resource)
  }
  
}

//public struct Betting {
//
//  public enum Error: Swift.Error {
//    case encodingFailed
//  }
//
//  private let group: MultiThreadedEventLoopGroup
//
//  private var loop: EventLoop {
//    return group.next()
//  }
//
//  public init(group: MultiThreadedEventLoopGroup = MultiThreadedEventLoopGroup(numThreads: 1)) {
//    self.group = group
//  }
//
//  public func place(instructions: [PlaceInstruction]) -> EventLoopFuture<PlaceExecutionReport> {
//    let promise: EventLoopPromise<PlaceExecutionReport> = loop.newPromise()
//    guard let data = try? JSONEncoder().encode(instructions) else {
//      promise.fail(error: Error.encodingFailed)
//    }
//    let url = Endpoint.Betting.placeOrders(instructions).url
//    let resource = Resource<PlaceExecutionReport>(url: url,
//                                                  method: HttpMethod.post(data))
//    return Webservice.shared.load(resource)
//  }
//
//}


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

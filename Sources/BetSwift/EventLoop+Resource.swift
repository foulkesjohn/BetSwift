import Foundation
import NIO

public enum EventLoopError: Swift.Error {
  case unknown
}

public extension EventLoop {

  func resource<Input: Codable & EndpointType & ResourceType>(input: Input) -> EventLoopFuture<Input.ReturnType>? {
    let operation = Operation(input)
    guard let data = try? JSONEncoder().encode(operation) else { return nil }
      let resource = Resource<OperationResult<Input.ReturnType>>(url: input.url,
                                                                 method: HttpMethod.post(data))
    return Webservice.shared.load(resource).flatMap {
      [unowned self]
      opResult in
      return self.makeSucceededFuture(opResult.result)
    }
  }
  
}

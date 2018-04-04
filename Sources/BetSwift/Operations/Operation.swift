import Foundation

public struct Operation<Operation: Codable & ResourceType>: Codable {
  public let jsonrpc = "2.0"
  public let id = 1
  public let params: Operation
  public let method: String
  public init(_ params: Operation) {
    self.params = params
    self.method = Operation.method
  }
}

public struct OperationResult<Result: Codable>: Codable {
  public let jsonrpc: String
  public let result: Result
  public let id: Int
}

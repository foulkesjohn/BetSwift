import Foundation

public struct CancelOrders: Codable,
                            EndpointType,
                            ResourceType {
  public typealias ReturnType = CancelExecutionReport
  
  public var url: URL {
    return Endpoint.Betting.cancelOrders.url
  }
  
  public static let method = "SportsAPING/v1.0/cancelOrders"
  
  public struct CancelInstruction: Codable {
    public let betId: String
    public let sizeReduction: Float?
    public init(betId: String, sizeReduction: Float? = nil) {
      self.betId = betId
      self.sizeReduction = sizeReduction
    }
  }
  
  public let marketId: String?
  public let customerRef: String?
  public let instructions: [CancelInstruction]?
  
  public init(marketId: String? = nil,
              customerRef: String? = nil,
              instructions: [CancelInstruction]? = nil) {
    self.marketId = marketId
    self.customerRef = customerRef
    self.instructions = instructions
  }
  
  public static func cancelOrders(marketId: String, betId: String) -> CancelOrders {
    let instruction = CancelOrders.CancelInstruction(betId: betId)
    return CancelOrders(marketId: marketId,
                        instructions: [instruction])
  }
}

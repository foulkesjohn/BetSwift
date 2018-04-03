import Foundation

public struct ListOrders: Codable, EndpointType, ResourceType {
  public typealias ReturnType = CurrentOrderSummaryReport
  public let betIds: Set<String>?
  public let marketIds: Set<String>?
  public var url: URL {
    return Endpoint.Betting.placeOrders.url
  }
  public init(betIds: Set<String>? = nil,
              marketIds: Set<String>? = nil) {
    self.betIds = betIds
    self.marketIds = marketIds
  }
}

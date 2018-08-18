import Foundation

public struct ListOrders: Codable,
                          EndpointType,
                          ResourceType {
  public typealias ReturnType = CurrentOrderSummaryReport
  
  public var url: URL {
    return Endpoint.Betting.listCurrentOrders.url
  }
  
  public static let method = "SportsAPING/v1.0/listCurrentOrders"

  public let betIds: Set<String>?
  public let marketIds: Set<String>?

  public init(betIds: Set<String>? = nil,
              marketIds: Set<String>? = nil) {
    self.betIds = betIds
    self.marketIds = marketIds
  }
}

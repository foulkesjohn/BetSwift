import Foundation

public struct CurrentOrderSummaryReport: Codable {
  public struct CurrentOrderSummary: Codable {
    public let betId: String
    public let marketId: String
    public let selectionId: Int
    public let handicap: Double
    public let priceSize: PriceSize
    public let bspLiability: Double
    public let side: Side
    public let status: OrderStatus
    public let persistenceType: PersistenceType
    public let orderType: OrderType
    public let placedDate: Date
    public let matchedDate: Date?
    public let averagePriceMatched: Double?
    public let sizeMatched: Double?
    public let sizeRemaining: Double?
    public let sizeLapsed: Double?
    public let sizeCancelled: Double?
    public let sizeVoided: Double?
    public let customerOrderRef: String?
    public let customerStrategyRef: String?
  }
  public let moreAvailable: Bool
  public let currentOrders: [CurrentOrderSummary]
}

public struct PriceSize: Codable {
  public let price: Double
  public let size: Double
}

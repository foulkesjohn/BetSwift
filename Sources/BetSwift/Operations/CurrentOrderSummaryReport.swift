import Foundation

public struct CurrentOrderSummaryReport: Codable {
  public struct CurrentOrderSummary: Codable {
    public let betId: String
    public let marketId: String
    public let selectionId: Int
    public let handicap: Float
    public let priceSize: PriceSize
    public let bspLiability: Float
    public let side: Side
    public let status: OrderStatus
    public let persistenceType: PersistenceType
    public let orderType: OrderType
    public let placedDate: Date
    public let matchedDate: Date?
    public let averagePriceMatched: Float?
    public let sizeMatched: Float?
    public let sizeRemaining: Float?
    public let sizeLapsed: Float?
    public let sizeCancelled: Float?
    public let sizeVoided: Float?
    public let customerOrderRef: String?
    public let customerStrategyRef: String?
  }
  public let moreAvailable: Bool
  public let currentOrders: [CurrentOrderSummary]
}

public struct PriceSize: Codable {
  public let price: Float
  public let size: Float
}

import Foundation
import NIO

public protocol ResourceType {
  associatedtype ReturnType: Codable
  static var method: String { get }
}

public struct PlaceOrders: Codable, EndpointType, ResourceType {
  public typealias ReturnType = PlaceExecutionReport
  
  public var url: URL {
    return Endpoint.Betting.placeOrders.url
  }
  
  public static let method = "SportsAPING/v1.0/placeOrders"

  public let marketId: String
  public let instructions: [PlaceInstruction]
  public let customerRef: String?
  public let marketVersion: String?
  public let customerStrategyRef: String?
  public let async: Bool?
  
  public init(marketId: String,
              instructions: [PlaceInstruction],
              customerRef: String? = nil,
              marketVersion: String? = nil,
              customerStrategyRef: String? = nil,
              async: Bool? = nil) {
    self.marketId = marketId
    self.instructions = instructions
    self.customerRef = customerRef
    self.marketVersion = marketVersion
    self.customerStrategyRef = customerStrategyRef
    self.async = async
  }
}

public struct PlaceInstruction: Codable  {
  public struct LimitOrder: Codable {
    public enum TimeInForce: String, Codable {
      case fillOrKill = "FILL_OR_KILL"
    }
    public let size: Float
    public let price: Float
    public let persistenceType: PersistenceType
    public let timeInForce: TimeInForce?
    public init(size: Float,
                price: Float,
                persistenceType: PersistenceType,
                timeInForce: TimeInForce? = nil) {
      self.size = size
      self.price = price
      self.persistenceType = persistenceType
      self.timeInForce = timeInForce
    }
  }
  public let orderType: OrderType
  public let selectionId: Int
  public let handicap: Float?
  public let side: Side
  public let limitOrder: LimitOrder?
  public let customerOrderRef: String?
  
  public init(orderType: OrderType,
              selectionId: Int,
              handicap: Float? = nil,
              side: Side,
              limitOrder: LimitOrder? = nil,
              customerOrderRef: String? = nil) {
    self.orderType = orderType
    self.selectionId = selectionId
    self.handicap = handicap
    self.side = side
    self.limitOrder = limitOrder
    self.customerOrderRef = customerOrderRef
  }
}

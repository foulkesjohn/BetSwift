import Foundation

public enum OrderType: String, Codable {
  case limit = "LIMIT"
  case limitOnClose = "LIMIT_ON_CLOSE"
  case marketOnClose = "MARKET_ON_CLOSE"
}

import Foundation

public enum PersistenceType: String, Codable {
  case lapse = "LAPSE"
  case persist = "PERSIST"
  case marketOnClose = "MARKET_ON_CLOSE"
}

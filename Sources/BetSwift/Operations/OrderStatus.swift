import Foundation

public enum OrderStatus: String, Codable {
  case pending = "PENDING"
  case executable = "EXECUTABLE"
  case executionComplete = "EXECUTION_COMPLETE"
  case expired = "EXPIRED"
}

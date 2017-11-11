import Foundation

public enum Op {
  
  case connection(Connection)
  case authentication(Authentication)
  case marketSubscription(MarketSubscription)
  case mcm(ChangeMessage<MarketChange>)
  case heartbeat(Heartbeat)
  case status(Status)
  case error
  
  public func next() -> Op? {
    switch self {
    case .mcm(_),
         .status(_):
      return .heartbeat(Heartbeat(id: 1))
    default:
      return nil
    }
  }
}

public func ==(lhs: Op, rhs: Op) -> Bool {
  return false
}

extension Op: Codable {
  
  enum OpKeys: String, CodingKey {
    case op
  }
  
  enum Error: Swift.Error {
    case encoding
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: OpKeys.self)
    let op = try container.decode(String.self, forKey: .op)
    switch op {
    case "connection":
      self = try .connection(Connection(from: decoder))
    case "mcm":
      self = try .mcm(ChangeMessage<MarketChange>(from: decoder))
    case "status":
      self = try .status(Status(from: decoder))
    default:
      self = .error
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .authentication(let authentication):
      try container.encode(authentication)
    case .heartbeat(let heartbeat):
      try container.encode(heartbeat)
    case .marketSubscription(let marketSubscription):
      try container.encode(marketSubscription)
    default:
      throw Error.encoding
    }
  }
  
}

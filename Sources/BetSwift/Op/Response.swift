import Foundation

public struct Connection: Codable {
  public let id: String
  enum CodingKeys: String, CodingKey {
    case id = "connectionId"
  }
}

public protocol ChangeType {}

public struct ChangeMessage<Change: Decodable>: Decodable, ChangeType {
  public let id: Int
  public let ct: String?
  public let initialClk: String?
  public let clk: String
  public let mc: [Change]?
  public let pt: Date
  public let identifier = UUID().uuidString
}

public struct MarketChange: Decodable {
  public let img: Bool = false
  public let id: String
  public let marketDefinition: MarketDefinition?
  public let rc: [RunnerChange]?
  public let tv: Float?
  public let identifier = UUID().uuidString
  
  public struct MarketDefinition: Decodable {
    public struct Runner: Decodable {
      public let id: Int
      public let status: Status
      public enum Status: String, Decodable {
        case active = "ACTIVE"
        case winner = "WINNER"
        case loser = "LOSER"
        case placed = "PLACED"
        case removedVacant = "REMOVED_VACANT"
        case removed = "REMOVED"
        case hidden = "HIDDEN"
      }
    }
    public let runners: [Runner]?
    public let inPlay: Bool
    public let status: String
  }
  public struct RunnerChange: Decodable {
    public let id: Int
    public let ltp: Float?
    public let batb: RunnerChangeTriple?
    public let batl: RunnerChangeTriple?
    public let atl: RunnerChangeTuple?
    public let atb: RunnerChangeTuple?
    public let tv: Float?
  }
}

public struct Status: Codable {
  public let id: Int
  public let code: String
  enum CodingKeys: String, CodingKey {
    case id
    case code = "statusCode"
  }
}


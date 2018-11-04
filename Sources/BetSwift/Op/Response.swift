import Foundation

public struct Connection: Codable {
  public let id: String
  enum CodingKeys: String, CodingKey {
    case id = "connectionId"
  }
}

public protocol ChangeType {}

public struct ChangeMessage<Change: Codable>: Codable, ChangeType {
  public let id: Int
  public let ct: String?
  public let initialClk: String?
  public let clk: String?
  public let mc: [Change]?
  public let pt: Date
  public let identifier = UUID().uuidString
  public init(id: Int,
              ct: String? = nil,
              initialClk: String? = nil,
              clk: String,
              mc: [Change]? = nil,
              pt: Date = Date()) {
    self.id = id
    self.ct = ct
    self.initialClk = initialClk
    self.clk = clk
    self.mc = mc
    self.pt = pt
  }
}

public struct MarketChange: Codable {
  public let img: Bool = false
  public let id: String
  public let marketDefinition: MarketDefinition?
  public let rc: [RunnerChange]?
  public let tv: Double?
  public let identifier = UUID().uuidString
  
  public struct MarketDefinition: Codable {
    public struct Runner: Codable {
      public let id: Int
      public let status: Status
      public enum Status: String, Codable {
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
    public let eventTypeId: String
    public init(runners: [Runner] = [],
                inPlay: Bool = true,
                status: String = Runner.Status.active.rawValue,
                eventTypeId: String) {
      self.runners = runners
      self.inPlay = inPlay
      self.status = status
      self.eventTypeId = eventTypeId
    }
  }
  public struct RunnerChange: Codable {
    public let id: Int
    public let ltp: Double?
    public let batb: RunnerChangeTriple?
    public let batl: RunnerChangeTriple?
    public let atl: RunnerChangeTuple?
    public let atb: RunnerChangeTuple?
    public let tv: Double?
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


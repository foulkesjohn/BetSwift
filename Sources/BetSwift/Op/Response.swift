import Foundation

public struct Connection: Codable {
  let id: String
  enum CodingKeys: String, CodingKey {
    case id = "connectionId"
  }
}

public protocol ChangeType {}

public struct ChangeMessage<Change: Decodable>: Decodable, ChangeType {
  let id: Int
  let ct: String?
  let initialClk: String?
  let clk: String
  let mc: [Change]
}

public struct MarketChange: Decodable {
  let img: Bool?
  let id: String
  let marketDefinition: MarketDefinition?
  let rc: [RunnerChange]?
  
  public struct MarketDefinition: Decodable {
    public struct Runner: Decodable {
      let id: Int
      let status: String
    }
    let runners: [Runner]?
  }
  public struct RunnerChange: Decodable {
    let id: Int
    let ltp: DeltaChangeValue?
    let batb: RunnerChangeTriple?
    let batl: RunnerChangeTriple?
  }
}

public struct Status: Codable {
  let id: Int
  let code: String
  enum CodingKeys: String, CodingKey {
    case id
    case code = "statusCode"
  }
}

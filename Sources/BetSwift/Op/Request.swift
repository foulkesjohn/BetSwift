import Foundation

public struct Authentication: Codable {
  let id: Int
  let appKey: String
  let session: String
  let op = "authentication"
  public init(id: Int, appKey: String, session: String) {
    self.id = id
    self.appKey = appKey
    self.session = session
  }
}

public struct Heartbeat: Codable {
  let id: Int
  let op = "heartbeat"
}

public struct MarketFilter: Codable {
  let marketIds: [String]?
  let bspMarket: Bool?
  let bettingTypes: [String]?
  let eventTypeIds: [String]?
  let turnInPlayEnabled: Bool?
  let marketTypes: [String]?
  let venues: [String]?
  let countryCodes: [String]?
  public init(marketIds: [String]?,
              bspMarket: Bool?,
              bettingTypes: [String]?,
              eventTypeIds: [String]?,
              turnInPlayEnabled: Bool?,
              marketTypes: [String]?,
              venues: [String]?,
              countryCodes: [String]?) {
    self.marketIds = marketIds
    self.bspMarket = bspMarket
    self.bettingTypes = bettingTypes
    self.eventTypeIds = eventTypeIds
    self.turnInPlayEnabled = turnInPlayEnabled
    self.marketTypes = marketTypes
    self.venues = venues
    self.countryCodes = countryCodes
  }
}

public struct MarketDataFilter: Codable {
  let fields: [String]
  let ladderLevels: Int
  public init(fields: [String], ladderLevels: Int) {
    self.fields = fields
    self.ladderLevels = ladderLevels
  }
}

public struct MarketSubscription: Codable {
  let id: Int
  let marketFilter: MarketFilter
  let marketDataFilter: MarketDataFilter
  let initialClk: String?
  let clk: String?
  let op = "marketSubscription"
  public init(id: Int,
              marketFilter: MarketFilter,
              marketDataFilter: MarketDataFilter,
              initialClk: String? = nil,
              clk: String? = nil) {
    self.id = id
    self.marketFilter = marketFilter
    self.marketDataFilter = marketDataFilter
    self.initialClk = initialClk
    self.clk = clk
  }
  public func with(initialClk: String?, clk: String?) -> MarketSubscription {
    return MarketSubscription(id: id,
                              marketFilter: marketFilter,
                              marketDataFilter: marketDataFilter,
                              initialClk: initialClk,
                              clk: clk)
  }
}


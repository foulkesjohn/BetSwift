import Foundation
import XCTest

@testable import BetSwift

typealias JSONDictionary = [String: Any]

func ==(lhs: JSONDictionary, rhs: JSONDictionary) -> Bool {
  return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

class OpTest: XCTestCase {
  
  static var allTests = [
    ("testAuthenticationEncodesToJson", testAuthenticationEncodesToJson),
    ("testHeartbeatEncodesToJson", testHeartbeatEncodesToJson),
    ("testMarketSubscriptionEncodesToJson", testMarketSubscriptionEncodesToJson),
    ("testConnectionDecodesFromJson", testConnectionDecodesFromJson),
    ("testMarketChangeDecodesFromJson", testMarketChangeDecodesFromJson),
    ("testStatusDecodesFromJson", testStatusDecodesFromJson),
  ]
  
  let decoder = JSONDecoder()
  let encoder = JSONEncoder()
  
  func testAuthenticationEncodesToJson() {
    let auth = Authentication(id: 1, appKey: "appKey", session: "session")
    let expectedJson: JSONDictionary = ["op": "authentication",
                                        "id": 1,
                                        "appKey": "appKey",
                                        "session": "session"]
    let data = try! encoder.encode(auth)
    let output = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    XCTAssert(output == expectedJson)
  }
  
  func testHeartbeatEncodesToJson() {
    let heartbeat = Heartbeat(id: 1)
    let expectedJson: JSONDictionary = ["op": "heartbeat",
                                        "id": 1]
    let data = try! encoder.encode(heartbeat)
    let output = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    XCTAssert(output == expectedJson)
  }
  
  func testMarketSubscriptionEncodesToJson() {
    let marketFilter = MarketFilter(marketIds: nil,
                                    bspMarket: nil,
                                    bettingTypes: nil,
                                    eventTypeIds: ["7"],
                                    turnInPlayEnabled: nil,
                                    marketTypes: ["PLACE", "WIN"],
                                    venues: nil,
                                    countryCodes: ["GB"])
    let marketDataFilter = MarketDataFilter(fields: ["EX_BEST_OFFERS",
                                                     "EX_MARKET_DEF",
                                                     "EX_LTP"],
                                            ladderLevels: 3)
    let marketSubscription = MarketSubscription(id: 1,
                                                marketFilter: marketFilter,
                                                marketDataFilter: marketDataFilter)
    let expectedJson: JSONDictionary = ["op": "marketSubscription",
                                        "id": 1,
                                        "marketFilter": ["eventTypeIds": ["7"],
                                                         "marketTypes": ["PLACE", "WIN"],
                                                         "countryCodes": ["GB"]],
                                        "marketDataFilter": ["fields": ["EX_BEST_OFFERS",
                                                                        "EX_MARKET_DEF",
                                                                        "EX_LTP"],
                                                             "ladderLevels": 3]]
    let data = try! encoder.encode(marketSubscription)
    let output = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    XCTAssert(output == expectedJson)
  }
  
  func testConnectionDecodesFromJson() {
    let json = "{ \"op\": \"connection\", \"connectionId\": \"connectionId\"}"
    let data = json.data(using: .utf8)!
    let connection = try! decoder.decode(Connection.self, from: data)
    XCTAssertEqual(connection.id, "connectionId")
  }
  
  func testMarketChangeDecodesFromJson() {
    let testDir = ProcessInfo.processInfo.environment["TEST_DIR"]!
    let path = "mcm.json"
    let filePath = URL(fileURLWithPath: testDir + path)
    let data = try! Data(contentsOf: filePath)
    let marketChange = try! decoder.decode(ChangeMessage<MarketChange>.self, from: data)
    XCTAssertEqual(marketChange.id, 1)
  }
  
  func testStatusDecodesFromJson() {
    let json = "{ \"op\": \"status\", \"id\": 1, \"statusCode\": \"code\" }"
    let data = json.data(using: .utf8)!
    let status = try! decoder.decode(Status.self, from: data)
    XCTAssertEqual(status.id, 1)
    XCTAssertEqual(status.code, "code")
  }
  
}

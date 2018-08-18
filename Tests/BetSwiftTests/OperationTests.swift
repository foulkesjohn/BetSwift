import Foundation
import XCTest

@testable import BetSwift

class OperationTests: XCTestCase {
  
  static var allTests = [
    ("testPlaceExecutionReport", testPlaceExecutionReport),
  ]
  
  func testPlaceExecutionReport() throws {
    let response = """
      {"jsonrpc":"2.0","result":{"status":"SUCCESS","marketId":"1.142261175","instructionReports":[{"status":"SUCCESS","instruction":{"selectionId":17736833,"limitOrder":{"size":2.0,"price":2.0,"persistenceType":"PERSIST"},"orderType":"LIMIT","side":"LAY"},"betId":"121462130915","placedDate":"2018-04-07T08:24:29.000Z","averagePriceMatched":0.0,"sizeMatched":0.0,"orderStatus":"EXECUTABLE"}]},"id":1}
    """
    let data = response.data(using: .utf8)!
    let report = try! decoder.decode(OperationResult<PlaceExecutionReport>.self, from: data)
    XCTAssertNotNil(report)
  }
  
  func testCurrentOrderSummaryReport() throws {
    let response = """
{\"jsonrpc\":\"2.0\",\"result\":{\"currentOrders\":[{\"betId\":\"121467014138\",\"marketId\":\"1.142261280\",\"selectionId\":6275605,\"handicap\":0.0,\"priceSize\":{\"price\":2.0,\"size\":2.0},\"bspLiability\":0.0,\"side\":\"LAY\",\"status\":\"EXECUTABLE\",\"persistenceType\":\"PERSIST\",\"orderType\":\"LIMIT\",\"placedDate\":\"2018-04-07T09:25:33.000Z\",\"averagePriceMatched\":0.0,\"sizeMatched\":0.0,\"sizeRemaining\":2.0,\"sizeLapsed\":0.0,\"sizeCancelled\":0.0,\"sizeVoided\":0.0,\"regulatorCode\":\"GIBRALTAR REGULATOR\"}],\"moreAvailable\":false},\"id\":1}
"""
    let data = response.data(using: .utf8)!
    let report = try! decoder.decode(OperationResult<CurrentOrderSummaryReport>.self, from: data)
    XCTAssertNotNil(report)
  }
  
  func testCancelExecutionReport() throws {
    let response = """
{\"jsonrpc\":\"2.0\",\"result\":{\"status\":\"SUCCESS\",\"marketId\":\"1.142261285\",\"instructionReports\":[{\"status\":\"SUCCESS\",\"instruction\":{\"betId\":\"121467405856\"},\"sizeCancelled\":2.0,\"cancelledDate\":\"2018-04-07T09:29:56.000Z\"}]},\"id\":1}
"""
    let data = response.data(using: .utf8)!
    let report = try! decoder.decode(OperationResult<CancelExecutionReport>.self, from: data)
    XCTAssertNotNil(report)
  }
  
}

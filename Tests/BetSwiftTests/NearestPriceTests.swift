import Foundation
import XCTest

@testable import BetSwift

class NearestPriceTest: XCTestCase {
  
  static var allTests = [
    ("testNearestPrice", testNearestPrice),
  ]
  
  func testNearestPrice() throws {
    let data: [(Double, Double)] = [
      (0.1, 1.01), (1, 1.01), (1000.1, 1000), (2000, 1000.0), (1.01, 1.01), (2.02, 2.02),
      (3.05, 3.05), (4.1, 4.1), (6.2, 6.2), (10.5, 10.5), (21, 21), (32, 32), (55, 55),
      (110, 110), (1.014, 1.01), (2.029, 2.02),
      (3.074, 3.05), (3.075, 3.1), (4.14, 4.1), (4.15, 4.2), (6.29, 6.2), (6.3, 6.4),
      (10.74, 10.5), (10.75, 11), (21.4, 21), (21.5, 22), (32.9, 32), (33, 34), (57.4, 55),
      (57.5, 60), (114, 110), (115, 120), (Double.infinity, 1000.0)
    ]
    data.forEach {
      pair in
      let price = pair.0
      let expected = pair.1
      let result = nearestPrice(price: price, cutoffs: CUTOFFS)
      XCTAssertEqual(result, expected)
    }
  }
}

import Foundation
import XCTest

@testable import BetSwift

class PriceChangeTest: XCTestCase {
  
  static var allTests = [
    ("testApplyChangesNewChange", testApplyChangesNewChange),
    ("testApplyChangesNewReplce", testApplyChangesNewReplce),
    ("testApplyChangesNewReplce1", testApplyChangesNewReplce1),
    ("testApplyChangesNewRemove", testApplyChangesNewRemove)
  ]
  
  func testApplyChangesNewChange() throws {
    let book_update = [[0, 36, 0.57]]
    let current: RunnerChangeTriple = []
    let expected = [[0, 36, 0.57]]
    
    let result = current.apply(changes: book_update)
    XCTAssertTrue(result == expected)
  }
  
  func testApplyChangesNewReplce() throws {
    let book_update = [[0, 36, 0.57]]
    let current = [[0, 36, 10.57], [1, 38, 3.57]]
    let expected = [[0, 36, 0.57], [1, 38, 3.57]]
    
    let result = current.apply(changes: book_update)
    XCTAssertTrue(result == expected)
  }
  
  func testApplyChangesNewReplce1() throws {
    let book_update = [[2, 0, 0], [1, 1.01, 9835.74], [0, 1.02, 1126.22]]
    let current = [[1, 1.01, 9835.74], [0, 1.02, 1126.22]]
    let expected = [[1, 1.01, 9835.74], [0, 1.02, 1126.22]]
    
    let result = current.apply(changes: book_update)
    XCTAssertTrue(result == expected)
  }
  
  func testApplyChangesNewRemove() throws {
    let book_update = [[0, 36, 0], [1, 38, 0], [0, 38, 3.57]]
    let current = [[0, 36, 10.57], [1, 38, 3.57]]
    let expected = [[0, 38, 3.57]]
    
    let result = current.apply(changes: book_update)
    XCTAssertTrue(result == expected)
  }

}

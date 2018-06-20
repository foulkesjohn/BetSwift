import Foundation
import XCTest

@testable import BetSwift

class PriceChangeTest: XCTestCase {
  
  static var allTests = [
    ("testApplyChangesNewChange", testApplyChangesNewChange),
    ("testApplyChangesNewReplce", testApplyChangesNewReplce),
    ("testApplyChangesNewReplce1", testApplyChangesNewReplace1),
    ("testApplyChangesNewRemove", testApplyChangesNewRemove)
  ]
  
  func testApplyChangesNewChange() throws {
    let book_update: RunnerChangeTriple = [[0, 36, 0.57]]
    var current: RunnerChangeTriple = []
    let expected: RunnerChangeTriple = [[0, 36, 0.57]]
    
    current.apply(changes: book_update)
    XCTAssertTrue(current == expected)
  }
  
  func testApplyChangesNewReplce() throws {
    let book_update: RunnerChangeTriple = [[0, 36, 0.57]]
    var current: RunnerChangeTriple = [[0, 36, 10.57], [1, 38, 3.57]]
    let expected: RunnerChangeTriple = [[0, 36, 0.57], [1, 38, 3.57]]
    
    current.apply(changes: book_update)
    XCTAssertTrue(current == expected)
  }
  
  func testApplyChangesNewReplace1() throws {
    let book_update: RunnerChangeTriple = [[2, 0, 0], [1, 1.01, 9835.74], [0, 1.02, 1126.22]]
    var current: RunnerChangeTriple = [[1, 1.01, 9835.74], [0, 1.02, 1126.22]]
    let expected: RunnerChangeTriple = [[1, 1.01, 9835.74], [0, 1.02, 1126.22]]
    
    current.apply(changes: book_update)
    XCTAssertTrue(current == expected)
  }
  
  func testApplyChangesNewRemove() throws {
    let book_update: RunnerChangeTriple = [[0, 36, 0], [1, 38, 0], [0, 38, 3.57]]
    var current: RunnerChangeTriple = [[0, 36, 10.57], [1, 38, 3.57]]
    let expected: RunnerChangeTriple = [[0, 38, 3.57]]
    
    current.apply(changes: book_update)
    XCTAssertTrue(current == expected)
  }

}

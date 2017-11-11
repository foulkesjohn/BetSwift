import Foundation
import XCTest

@testable import BetSwift

class DataExtensionsTest: XCTestCase {
  
  static var allTests = [
    ("testSplit", testSplit),
  ]
  
  func testSplit() throws {
    let parts = ["command one\r\n",
                 "command two\r\n",
                 "command three\r\n"]
    let delimeter = "\r\n".data(using: .utf8)!
    let data = parts.joined().data(using: .utf8)
    let splits = data?.split(delimeter).map {
      data in
      return String(data: data, encoding: .utf8)!
    }
    XCTAssertEqual(splits![0], "command one") 
    XCTAssertEqual(splits![1], "command two")
    XCTAssertEqual(splits![2], "command three")
  }
  
}

import XCTest

@testable import BetSwiftTests

XCTMain([
	testCase(DataExtensionsTest.allTests),
  testCase(OpTest.allTests),
  testCase(PriceChangeTest.allTests)
])


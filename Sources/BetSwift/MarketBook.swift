import Foundation

public struct RunnerBook {
  let id: String
  let lastPriceTraded: Float
  let totalMatched: Float
  let availableToBack: RunnerChangeTriple
  let availableToLay: RunnerChangeTriple
  let bestAvailableToBack: RunnerChangeTriple
  let bestAvailableToLay: RunnerChangeTriple
}

public struct MarketBook {
  public typealias DictionaryType = [String: [RunnerBook]]
  
  fileprivate var runners = DictionaryType()
  
  public init(runners: DictionaryType = [:]) {
    self.runners = runners
  }
  
}

extension MarketBook: Collection {
  public typealias Index = DictionaryType.Index
  public typealias Element = DictionaryType.Element
  
  public var startIndex: Index { return runners.startIndex }
  public var endIndex: Index { return runners.endIndex }
  
  public subscript(index: Index) -> Iterator.Element {
    get { return runners[index] }
  }
  
  public func index(after i: Index) -> Index {
    return runners.index(after: i)
  }
}

extension MarketBook {
  public subscript(marketId: String) -> [RunnerBook] {
    get { return runners[marketId] ?? [] }
    set { runners[marketId] = newValue }
  }
}

extension MarketBook {
  public mutating func insert(_ runnerBook: RunnerBook) {
    var runnerBooks = self[runnerBook.id]
    runnerBooks.append(runnerBook)
    self[runnerBook.id] = runnerBooks
  }
}

extension MarketBook: ExpressibleByDictionaryLiteral {
  public typealias Key = String
  public typealias Value = [RunnerBook]
  
  public init(dictionaryLiteral elements: (String, [RunnerBook])...) {
    for (runnerId, changesInMarket) in elements {
      runners[runnerId] = changesInMarket
    }
  }
}

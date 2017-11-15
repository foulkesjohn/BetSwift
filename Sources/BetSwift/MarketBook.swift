import Foundation

public struct RunnerBook {
  let id: Int
  public var lastPriceTraded: Float
  public var totalMatched: Float
  public var availableToBack: RunnerChangeTriple
  public var availableToLay: RunnerChangeTriple
  public var bestAvailableToBack: RunnerChangeTriple
  public var bestAvailableToLay: RunnerChangeTriple
  public var isActive: Bool
  public init(id: Int,
              lastPriceTraded: Float = 0,
              totalMatched: Float = 0,
              availableToBack: RunnerChangeTriple = [],
              availableToLay: RunnerChangeTriple = [],
              bestAvailableToBack: RunnerChangeTriple = [],
              bestAvailableToLay: RunnerChangeTriple = [],
              isActive: Bool = true) {
    self.id = id
    self.totalMatched = totalMatched
    self.lastPriceTraded = lastPriceTraded
    self.totalMatched = totalMatched
    self.availableToBack = availableToBack
    self.availableToLay = availableToLay
    self.bestAvailableToBack = bestAvailableToBack
    self.bestAvailableToLay = bestAvailableToLay
    self.isActive = isActive
  }
}

public struct MarketCache {
  public typealias DictionaryType = [String: MarketBook]
  
  fileprivate var cache = DictionaryType()
  
  public init(cache: DictionaryType = DictionaryType()) {
    self.cache = cache
  }
  
  public mutating func insert(change: MarketChange) {
    if change.img || cache[change.id] == nil {
      if let definition = change.marketDefinition,
        let marketBook = MarketBook(definition: definition) {
        cache[change.id] = marketBook
      }
    } else if var marketBook = cache[change.id] {
      marketBook.insert(change)
      cache[change.id] = marketBook
    } 
  }
}

extension MarketCache: Collection {
  public typealias Index = DictionaryType.Index
  public typealias Element = DictionaryType.Element
  
  public var startIndex: Index { return cache.startIndex }
  public var endIndex: Index { return cache.endIndex }
  
  public subscript(index: Index) -> Iterator.Element {
    get { return cache[index] }
  }
  
  public func index(after i: Index) -> Index {
    return cache.index(after: i)
  }
}

public struct MarketBook {
  public typealias DictionaryType = [Int: RunnerBook]
  
  fileprivate var runners = DictionaryType()
  fileprivate(set) var definition: MarketChange.MarketDefinition
  fileprivate(set) var totalMatched: Float?
  
  public var inPlay: Bool {
    return definition.inPlay
  }
  
  public var status: String {
    return definition.status
  }
  
  public var overround: Float {
    let activeRunners = runners.filter { $0.value.isActive }
    return activeRunners.reduce(0) {
      acc, val in
      guard let price = val.value.bestAvailableToBack.one?.price else { return acc }
      return acc + (1 / price)
    }
  }
  
  public var underround: Float {
    let activeRunners = runners.filter { $0.value.isActive }
    return activeRunners.reduce(0) {
      acc, val in
      guard let price = val.value.bestAvailableToLay.one?.price else { return acc }
      return acc + (1 / price)
    }
  }
  
  public init?(definition: MarketChange.MarketDefinition) {
    guard let runners = definition.runners else { return nil }
    
    self.definition = definition
    self.runners = runners.reduce(DictionaryType()) {
      acc, runner in
      var runners = acc
      runners[runner.id] = RunnerBook(id: runner.id)
      return runners
    }
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
  public subscript(marketId: Int) -> RunnerBook? {
    get { return runners[marketId] }
    set { runners[marketId] = newValue }
  }
}

extension MarketBook {
  public mutating func insert(_ marketChange: MarketChange) {
    totalMatched = marketChange.tv
    if let definition = marketChange.marketDefinition {
      self.definition = definition
    }
    if let runnerChanges = marketChange.rc {
      for runnerChange in runnerChanges {
        let runner = marketChange.marketDefinition?.runners?.first { $0.id == runnerChange.id }
        let isActive = runner?.status == .active
        if var runnerBook = self[runnerChange.id] {
          if let ltp = runnerChange.ltp {
            runnerBook.lastPriceTraded = ltp
          }
          if let bestAvailableToBack = runnerChange.batb {
            runnerBook.bestAvailableToBack.apply(changes: bestAvailableToBack)
          }
          if let bestAvailableToLay = runnerChange.batl {
            runnerBook.bestAvailableToLay.apply(changes: bestAvailableToLay)
          }
          runnerBook.isActive = isActive
          self[runnerChange.id] = runnerBook
        } else {
          let runnerBook = RunnerBook(id: runnerChange.id,
                                      lastPriceTraded: runnerChange.ltp ?? 0,
                                      totalMatched: runnerChange.tv ?? 0,
                                      availableToBack: [],
                                      availableToLay: [],
                                      bestAvailableToBack: runnerChange.batb ?? [],
                                      bestAvailableToLay: runnerChange.batl ?? [],
                                      isActive: isActive)
          self[runnerChange.id] = runnerBook
        }
      }
    }
  }
}

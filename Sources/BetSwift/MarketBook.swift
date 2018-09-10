import Foundation

public struct RunnerBook {
  let id: Int
  public var lastPriceTraded: Double
  public var totalMatched: Double
  public var availableToBack: RunnerChangeTuple
  public var availableToLay: RunnerChangeTuple
  public var bestAvailableToBack: RunnerChangeTriple
  public var bestAvailableToLay: RunnerChangeTriple
  public var isActive: Bool
  public init(id: Int,
              lastPriceTraded: Double = 0,
              totalMatched: Double = 0,
              availableToBack: RunnerChangeTuple = [],
              availableToLay: RunnerChangeTuple = [],
              bestAvailableToBack: RunnerChangeTriple = [],
              bestAvailableToLay: RunnerChangeTriple = [],
              isActive: Bool = true) {
    self.id = id
    self.totalMatched = totalMatched
    self.lastPriceTraded = lastPriceTraded
    self.totalMatched = totalMatched
    self.availableToBack = availableToBack
    self.availableToBack.sort(by :<)
    self.availableToLay = availableToLay
    self.availableToLay.sort(by :<)
    self.bestAvailableToBack = bestAvailableToBack
    self.bestAvailableToBack.sort(by :<)
    self.bestAvailableToLay = bestAvailableToLay
    self.bestAvailableToLay.sort(by :<)
    self.isActive = isActive
  }
}

public struct MarketCache {
  public typealias DictionaryType = [String: MarketBook]
  
  fileprivate var cache = DictionaryType()
  
  public init(cache: DictionaryType = DictionaryType()) {
    self.cache = cache
  }
  
  public mutating func insert(change: MarketChange, publishTime: Date) {
    var marketBook: MarketBook?
    if change.img || cache[change.id] == nil {
      if let definition = change.marketDefinition {
        marketBook = MarketBook(id: change.id,
                                definition: definition)
      }
    } else if let book = cache[change.id] {
      marketBook = book
    }
    if var marketBook = marketBook {
      marketBook.insert(change,
                        publishTime: publishTime)
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

extension MarketCache {
  public subscript(id: String) -> MarketBook? {
    get { return cache[id] }
    set { cache[id] = newValue }
  }
}

public struct MarketBook {
  public typealias DictionaryType = [Int: RunnerBook]
  
  fileprivate var runners = DictionaryType()
  fileprivate(set) var definition: MarketChange.MarketDefinition
  public private(set) var totalMatched: Double?
  public private(set) var publishTime: Date?
  public private(set) var changeId: String?
  public let id: String
  
  public var inPlay: Bool {
    return definition.inPlay
  }
  
  public var status: String {
    return definition.status
  }
  
  public var overround: Double {
    return runners
      .filter { $0.value.isActive }
      .reduce(0) {
        acc, val in
        guard let price = val.value.bestAvailableToBack.one?.price,
          price != 0 else { return acc }
        return acc + (1 / price)
    }
  }
  
  public var underround: Double {
    return runners
      .filter { $0.value.isActive }
      .reduce(0) {
        acc, val in
        guard let price = val.value.bestAvailableToLay.one?.price,
          price != 0 else { return acc }
        return acc + (1 / price)
    }
  }
  
  public init(id: String, definition: MarketChange.MarketDefinition) {
    self.id = id
    let runners = definition.runners ?? []
    
    self.definition = definition
    self.runners = runners.reduce(DictionaryType()) {
      acc, runner in
      var runners = acc
      runners[runner.id] = RunnerBook(id: runner.id,
                                      isActive: runner.status == .active)
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
  public mutating func insert(_ marketChange: MarketChange,
                              publishTime: Date) {
    self.publishTime = publishTime
    self.changeId = marketChange.identifier
    totalMatched = marketChange.tv
    if let definition = marketChange.marketDefinition {
      self.definition = definition
      if let runners = definition.runners {
        for runner in runners {
          if var runnerBook = self[runner.id] {
            runnerBook.isActive = runner.status == .active
            self[runner.id] = runnerBook
          }
        }
      }
    }
    if let runnerChanges = marketChange.rc {
      for runnerChange in runnerChanges {
        let runner = marketChange.marketDefinition?.runners?.first { $0.id == runnerChange.id }
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
          if let availableToBack = runnerChange.atb {
            runnerBook.availableToBack.apply(priceChanges: availableToBack)
          }
          if let availableToLay = runnerChange.atl {
            runnerBook.availableToLay.apply(priceChanges: availableToLay)
          }
          if let totalMatched = runnerChange.tv {
            runnerBook.totalMatched = totalMatched
          }
          if let runner = runner {
            let isActive = runner.status == .active
            runnerBook.isActive = isActive
          }
          self[runnerChange.id] = runnerBook
        } else {
          let isActive = runner?.status == .active
          let runnerBook = RunnerBook(id: runnerChange.id,
                                      lastPriceTraded: runnerChange.ltp ?? 0,
                                      totalMatched: runnerChange.tv ?? 0,
                                      availableToBack:runnerChange.atb ?? [],
                                      availableToLay: runnerChange.atl ?? [],
                                      bestAvailableToBack: runnerChange.batb ?? [],
                                      bestAvailableToLay: runnerChange.batl ?? [],
                                      isActive: isActive)
          self[runnerChange.id] = runnerBook
        }
      }
    }
  }
}


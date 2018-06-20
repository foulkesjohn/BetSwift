import Foundation

public typealias DeltaChangeValue = Float
public typealias RunnerChangeDelta = [DeltaChangeValue]
public typealias RunnerChangeTuple = [RunnerChangeDelta]
public typealias RunnerChangeTriple = [RunnerChangeDelta]

extension Array where Element == DeltaChangeValue {
  public var level: DeltaChangeValue? {
    return self.count > 0 ? self[0] : nil
  }
  
  public var price: DeltaChangeValue? {
    return self.count > 1 ? self[1] : nil
  }
  
  public var size: DeltaChangeValue? {
    return self.count > 2 ? self[2] : nil
  }
}

extension Array where Element == RunnerChangeDelta {
  public var one: RunnerChangeDelta? {
    return self.count > 0 ? self[0] : nil
  }
  public var two: RunnerChangeDelta? {
    return self.count > 1 ? self[1] : nil
  }
  public var three: RunnerChangeDelta? {
    return self.count > 2 ? self[2] : nil
  }
}

func ==(lhs: RunnerChangeTriple, rhs: RunnerChangeTriple) -> Bool {
  return lhs.elementsEqual(rhs) {
    lhs, rhs in
    return lhs == rhs
  }
}

extension Array where Element == [DeltaChangeValue] {
  
  mutating func apply(changes: RunnerChangeTriple) {
    for change in changes {
      var updated = false
      for (count, trade) in enumerated() {
        if trade.level == change.level {
          if change.size == 0 {
            remove(at: count)
            updated = true
            break
          } else {
            self[count] = change
            updated = true
            break
          }
        }
      }
      if !updated && change.size != 0 {
        append(change)
      }
    }
  }
  
  mutating func apply(priceChanges: RunnerChangeTuple) {
    for change in priceChanges {
      var updated = false
      for (count, trade) in enumerated() {
        if trade.level == change.level {
          if change.price == 0 {
            remove(at: count)
            updated = true
            break
          } else {
            self[count] = change
            updated = true
            break
          }
        }
      }
      if !updated && change.price != 0 {
        append(change)
      }
    }
  }
  
}

import Foundation

public typealias DeltaChangeValue = Float
public typealias RunnerChangeDelta = [DeltaChangeValue]
public typealias RunnerChangeTriple = [RunnerChangeDelta]

extension Array where Element == DeltaChangeValue {
  var level: DeltaChangeValue? {
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
    var updated = false
    for change in changes {
      if count == 0 {
        append(change)
        break
      }
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
  
}

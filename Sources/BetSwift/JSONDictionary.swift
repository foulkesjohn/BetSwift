import Foundation

public typealias DeltaChangeValue = Double
public typealias RunnerChangeDelta = [DeltaChangeValue]
public typealias RunnerChangeTriple = [RunnerChangeDelta]

extension Array where Element == DeltaChangeValue {
  var level: DeltaChangeValue {
    return self[0]
  }
  
  var price: DeltaChangeValue {
    return self[1]
  }
  
  var size: DeltaChangeValue {
    return self[2]
  }
}

func ==(lhs: RunnerChangeTriple, rhs: RunnerChangeTriple) -> Bool {
  return lhs.elementsEqual(rhs) {
    lhs, rhs in
    return lhs == rhs
  }
}

extension Array where Element == [DeltaChangeValue] {
  
  func apply(changes: RunnerChangeTriple) -> RunnerChangeTriple {
    var mutableSelf = self
    var updated = false
    for change in changes {
      if mutableSelf.count > 0 {
        for i in 0...mutableSelf.count-1 {
          let trade = self[i]
          if trade.level == change.level {
            if change.size == 0 {
              updated = true
              mutableSelf.remove(at: i)
              break
            } else {
              updated = true
              mutableSelf[i] = change
              break
            }
          }
        } 
      }
      if !updated && change.size != 0 {
        mutableSelf.append(change)
      }
    }
    return mutableSelf
  }
 
}

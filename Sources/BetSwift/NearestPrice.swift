import Foundation

public typealias CutOffPair = (cutoff: Double, step: Double)

public let CUTOFFS: [CutOffPair] = [
  (2, 100),
  (3, 50),
  (4, 20),
  (6, 10),
  (10, 5),
  (20, 2),
  (30, 1),
  (50, 0.5),
  (100, 0.2),
  (1000, 0.1),
]

public let MIN_PRICE: Double = 1.01
public let MAX_PRICE: Double = 1000

public func nearestPrice(price: Double, cutoffs: [CutOffPair]) -> Double {
  if price <= MIN_PRICE {
    return MIN_PRICE
  }
  if price > MAX_PRICE {
    return MAX_PRICE
  }
  var step: Double = 100
  for pair in cutoffs {
    step = pair.step
    if price < pair.cutoff {
      break
    }
  }
  return round((price * step)) / step
}

public extension Double {
  func rounded(toPlaces places: Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

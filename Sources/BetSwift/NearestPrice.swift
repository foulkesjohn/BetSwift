import Foundation

public typealias CutOffPair = (cutoff: Float, step: Float)

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

public let MIN_PRICE: Float = 1.01
public let MAX_PRICE: Float = 1000

public func nearestPrice(price: Float, cutoffs: [CutOffPair]) -> Float {
  if price <= MIN_PRICE {
    return MIN_PRICE
  }
  if price > MAX_PRICE {
    return MAX_PRICE
  }
  var step: Float = 100
  for pair in cutoffs {
    step = pair.step
    if price < pair.cutoff {
      break
    }
  }
  return (price * step).rounded(toPlaces: 2)
}

public extension Float {
  func rounded(toPlaces places: Int) -> Float {
    let divisor = pow(10.0, Float(places))
    return (self * divisor).rounded() / divisor
  }
}

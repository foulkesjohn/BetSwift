import Foundation

public class Queue<T> {
  private var queue: [T] = []
  
  public init() {}

  public var count: Int {
    return queue.count
  }
  
  public var isEmpty: Bool {
    return queue.isEmpty
  }
  
  public func add(_ item: T) {
    queue.append(item)
  }
  
  public func pop() -> T {
    return queue.removeFirst()
  }

}

import Foundation

public enum Event<T: ChangeType> {
  case change(T)
  case error
}

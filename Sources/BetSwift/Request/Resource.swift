import Foundation

public let BASEURL = URL(string: "https://api.betfair.com/exchange/")!

public let decoder: JSONDecoder = {
  let decoder = JSONDecoder()
  if #available(OSX 10.13, *) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    decoder.dateDecodingStrategy = .formatted(formatter)
  }
  return decoder
}()

public enum HttpMethod {
  case get
  case post(Data)
}

extension HttpMethod {
  var method: String {
    switch self {
    case .get: return "GET"
    case .post: return "POST"
    }
  }
}

public struct Resource<A> {
  public let url: URL
  public let method: HttpMethod
  public let parse: (Data) -> A?
}

public protocol EndpointType {
  var url: URL { get }
}

public enum Endpoint {
  public enum Betting {
    case placeOrders
    case listCurrentOrders
    case cancelOrders
    private static let url = BASEURL.appendingPathComponent("betting/json-rpc/v1/")
    public var url: URL {
      switch self {
      case .placeOrders:
        return Betting.url.appendingPathComponent("placeOrders")
      case .listCurrentOrders:
        return Betting.url.appendingPathComponent("listCurrentOrders")
      case .cancelOrders:
        return Betting.url.appendingPathComponent("cancelOrders")
      }
    }
  }
}

public extension Resource where A: Decodable {
  init(url: URL, method: HttpMethod = .get) {
    self.url = url
    self.method = method
    self.parse = { try? decoder.decode(A.self, from: $0) }
  }
}

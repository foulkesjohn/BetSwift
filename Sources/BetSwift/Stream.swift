import Foundation
import Socket
import SSLService
import Dispatch

private let LINEENDING = "\r\n"
private let LINEENDINGBYTE = LINEENDING.data(using: .utf8)!

public enum Event<T: ChangeType> {
  case change(T)
  case error
}

public class Stream<T: ChangeType> {
  public typealias Handler = ((State, Stream<T>) -> Void)
  public enum State {
    case notConnected
    case connected
    case error
  }
  public struct Config {
    let endpoint: String
    let certPath: String
    let password: String
    let authentication: Authentication
    public init(endpoint: String,
                certPath: String,
                password: String,
                authentication: Authentication) {
      self.endpoint = endpoint
      self.certPath = certPath
      self.password = password
      self.authentication = authentication
    }
  }
  
  private let encoder = JSONEncoder()
  
  private let config: Config
  private let socket: Socket
  private let handler: Handler
  private var queue: Queue<Event<T>>
  private let dispatchQueue: DispatchQueue
  private var state: State = .notConnected {
    didSet {
      handler(state, self)
    }
  }
  
  public init(config: Config,
              queue: Queue<Event<T>>,
              dispatchQueue: DispatchQueue = DispatchQueue(label: "betswift.queue.stream"),
              handler: @escaping Handler) {
    self.config = config
    self.queue = queue
    self.dispatchQueue = dispatchQueue
    self.handler = handler
    
    socket = try! Socket.create()
    var sslConfig = SSLService.Configuration(withChainFilePath: config.certPath,
                                             withPassword: config.password,
                                             usingSelfSignedCerts: true)
    #if os(Linux)
      sslConfig = SSLService.Configuration(withCACertificateFilePath: nil,
                                           usingCertificateFile: config.certPath)
    #endif
    let sslService = try! SSLService(usingConfiguration: sslConfig)
    sslService?.skipVerification = true
    socket.delegate = sslService
  }
  
  public func start() throws {
    try socket.connect(to: config.endpoint,
                       port: 443)
    try! socket.setBlocking(mode: false)
    dispatchQueue.async {
      self.listen()
    }
  }
  
  public func send(_ op: Op) throws {
    if state == .connected {
      let sendMessage = message(from: op)
      print(sendMessage)
      try socket.write(from: sendMessage)
    } else {
      fatalError("Stream not connected")
    }
  }
  
  private func listen() {
    var allData = Data()
    while true {
      var data = Data(capacity: 1024)
      _ = try! self.socket.read(into: &data)
      if data.count > 0 {
        allData = allData + data
        if Set(data).intersection(LINEENDINGBYTE).count > 0 {
          let parts = allData.split(LINEENDINGBYTE)
          parts.forEach(process(_:))
          allData = Data()
        }
      }
    }
  }
  
  private func process(_ part: Data) {
    do {
      let op = try received(data: part)
      try process(op)
    } catch {
      print(String(data: part, encoding: .utf8) ?? "")
      print(error)
    }
  }
  
  private func process(_ op: Op) throws {
    switch op {
    case .connection(_):
      let op: Op = .authentication(config.authentication)
      let sendMessage = message(from: op)
      try socket.write(from: sendMessage)
    case .status(_):
      if state == .notConnected { state = .connected }
    case .mcm(let change):
      queue.add(.change(change as! T))
    default:
      if let next = op.next() {
        try send(next)
      }
    }
  }
  
  private func received(data: Data) throws -> Op {
    return try JSONDecoder().decode(Op.self, from: data)
  }
  
  private func message(from op: Op) -> String {
    let messageData = try! encoder.encode(op)
    let message = String(data: messageData,
                         encoding: .utf8)!
    return message + LINEENDING
  }
  
}

public extension Data {
  func split(_ data: Data) -> [Data] {
    var parts = [Data]()
    var mutableData = self
    
    while mutableData.count > 2 {
      let range = mutableData.range(of: data) ?? Range(uncheckedBounds: (0, mutableData.count))
      let partRange = Range(uncheckedBounds: (0, range.lowerBound))
      parts.append(mutableData.subdata(in: partRange))
      let removeRange = Range(uncheckedBounds: (partRange.lowerBound, partRange.upperBound + 2))
      mutableData.removeSubrange(removeRange)
    }
    
    return parts
  }
}

public extension Array where Element == Data {
  func values() -> [String] {
    return self.map {
      data in
      return String(data: data, encoding: .utf8)!
    }
  }
}


import Foundation
import NIOHTTP1
import NIOSSL

public struct SessionFetchParams {
  public let username: String
  public let password: String
  public let appKey: String
  public let certPath: String
  public let certPassword: String
  
  public init(username: String,
              password: String,
              appKey: String,
              certPath: String,
              certPassword: String) {
    self.username = username
    self.password = password
    self.appKey = appKey
    self.certPath = certPath
    self.certPassword = certPassword
  }
}

public class SessionToken {
  
  public class func fetch(params: SessionFetchParams,
                          handler: @escaping (String?) -> Void) {
    let url = URL(string: "https://identitysso-cert.betfair.com/api/certlogin")!
    let headers = HTTPHeaders([("X-Application", params.appKey),
                               ("Content-Type", "application/x-www-form-urlencoded")])
    let head = HTTPRequestHead(version: .init(major: 1, minor: 1),
                               method: .POST,
                               uri: url.absoluteString,
                               headers: headers)
    let body = "username=\(params.username)&password=\(params.password)"
    let bodyData = body.data(using: .utf8)!
    let request = Request(head: head, body: bodyData)
    let tlsConfig = tlsConfiguration(params: params)
    let client = try! HTTPClient(url: url,
                                 tlsConfiguration: tlsConfig)
    let connect = try! client.connect(request)
    connect.whenSuccess {
      response in
      if let token = try? JSONDecoder().decode(Token.self, from: response.body) {
        if token.loginStatus == .success {
          handler(token.sessionToken)
        }
      } else {
        handler(nil)
      }
    }
    connect.whenFailure {
      _ in
      handler(nil)
    }
  }
  
  private class func tlsConfiguration(params: SessionFetchParams) -> TLSConfiguration {
    let certChain = NIOSSLCertificateSource.file(params.certPath)
    let key = try! NIOSSLPrivateKey(file: params.certPath,
                                    format: NIOSSLSerializationFormats.pem) {
                                      closure in
      closure(params.certPassword.utf8)
    }
    let keySource = NIOSSLPrivateKeySource.privateKey(key)
    return TLSConfiguration.forClient(certificateChain: [certChain],
                                      privateKey: keySource)
  }
  
  public struct Token: Decodable {
    public enum Status: String, Decodable {
      case success = "SUCCESS"
    }
    let sessionToken: String?
    let loginStatus: Status
  }
  
}

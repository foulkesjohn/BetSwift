import Foundation
import KituraNet

public struct SessionFetchParams {
  public let username: String
  public let password: String
  public let appKey: String
  public let certPath: String
  public let certKey: String
  public let certPassword: String
  
  public init(username: String,
              password: String,
              appKey: String,
              certPath: String,
              certKey: String,
              certPassword: String) {
    self.username = username
    self.password = password
    self.appKey = appKey
    self.certPath = certPath
    self.certKey = certKey
    self.certPassword = certPassword
  }
}

public class SessionToken {
  
  public class func fetch(params: SessionFetchParams,
                   handler: @escaping (String?) -> Void) {
    let options = [ClientRequest.Options.method("POST"),
                   ClientRequest.Options.schema("https://"),
                   ClientRequest.Options.hostname("identitysso.betfair.com"),
                   ClientRequest.Options.path("api/certlogin"),
                   ClientRequest.Options.headers(["X-Application": params.appKey,
                                                  "Content-Type": "application/x-www-form-urlencoded"]),
                   ClientRequest.Options.sslCertificate(params.certPath),
                   ClientRequest.Options.sslKey(params.certPath),
                   ClientRequest.Options.sslKeyPassphrase(params.certPassword)]
    let body = "username=\(params.username)&password=\(params.password)"
    
    let request = HTTP.request(options) {
      response in
      var data = Data()
      if let response = response,
         let _ = try? response.readAllData(into: &data),
         let token = try? JSONDecoder().decode(Token.self, from: data) {
        if token.loginStatus == .success {
          handler(token.sessionToken)
        }
      } else {
        handler(nil)
      }
    }
    request.end(body)
  }
  
  public struct Token: Decodable {
    public enum Status: String, Decodable {
      case success = "SUCCESS"
    }
    let sessionToken: String?
    let loginStatus: Status
  }
  
}


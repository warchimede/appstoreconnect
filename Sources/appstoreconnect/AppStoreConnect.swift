import ArgumentParser
import Foundation
import SwiftJWT

struct AppStoreConnect: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "appstoreconnect",
    abstract: "An interface App Store Connect API",
    subcommands: [Profiles.self, Users.self]
  )

  static var dispatchGroup: DispatchGroup?

  static func key(for keyId: String) -> Data? {
    let keyFilePath = "\(FileManager.default.homeDirectoryForCurrentUser.path)/.appstoreconnect/private_keys/AuthKey_\(keyId.uppercased()).p8"
    guard FileManager.default.fileExists(atPath: keyFilePath) else { return nil }

    return FileManager.default.contents(atPath: keyFilePath)
  }

  static func request(endpoint: Endpoint, key: Data, keyId: String, issId: String) -> URLRequest {
    let header = Header(typ: "JWT", kid: keyId)
      let signer = JWTSigner.es256(privateKey: key)
      let claims = APIClaims(exp: Date(timeIntervalSinceNow: 3600), iss: issId)
      var jwt = JWT(header: header, claims: claims)
      let signedJWT = (try? jwt.sign(using: signer)) ?? ""

      var request = URLRequest(url: endpoint.url)
      request.addValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")

      return request
  }
}
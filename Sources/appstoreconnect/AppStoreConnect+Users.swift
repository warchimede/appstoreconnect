import ArgumentParser
import Foundation
import SwiftJWT

extension AppStoreConnect {
  struct Users: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print the users")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() throws {
      let keyFilePath = "\(FileManager.default.homeDirectoryForCurrentUser.path)/.appstoreconnect/private_keys/AuthKey_\(options.keyId.uppercased()).p8"

      guard FileManager.default.fileExists(atPath: keyFilePath), let key = FileManager.default.contents(atPath: keyFilePath)
      else {
        print("ERROR Key data")
        return
      }

      let header = Header(typ: "JWT", kid: options.keyId)
      let signer = JWTSigner.es256(privateKey: key)
      let claims = APIClaims(exp: Date(timeIntervalSinceNow: 3600), iss: options.issId)
      var jwt = JWT(header: header, claims: claims)
      let signedJWT = (try? jwt.sign(using: signer)) ?? ""

      var request = URLRequest(url: Endpoint.users.url)
      request.addValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")

      AppStoreConnect.dispatchGroup?.enter()
      URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
        if let error = error {
          print("ERROR RESPONSE \(error)")
          return
        }

        if let result = data.flatMap({ String(data: $0, encoding: .utf8) }) {
          print(result)
        } else {
          print("ERROR NO DATA")
        }
        AppStoreConnect.dispatchGroup?.leave()
      }).resume()
    }
  }
}
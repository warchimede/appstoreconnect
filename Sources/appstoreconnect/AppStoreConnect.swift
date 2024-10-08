import ArgumentParser
import Foundation
import JWTKit

@main
struct AppStoreConnect: AsyncParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "appstoreconnect",
    abstract: "An interface for the App Store Connect API",
    subcommands: [Profiles.self, Users.self]
  )

  private static func key(for keyId: String) -> Result<Data, AppStoreConnectError> {
    let keyFilePath = "\(FileManager.default.homeDirectoryForCurrentUser.path)/.appstoreconnect/private_keys/AuthKey_\(keyId.uppercased()).p8"
    guard FileManager.default.fileExists(atPath: keyFilePath)
    else { return .failure(.keyNotFound) }

    guard let keyData = FileManager.default.contents(atPath: keyFilePath)
    else { return .failure(.invalidKeyData) }

    return .success(keyData)
  }

  private static func createRequest(endpoint: Endpoint, key: Data, options: Options) -> URLRequest {
    let exp = ExpirationClaim(value: Date(timeIntervalSinceNow: 5 * 60))
    let iss = IssuerClaim(value: options.issId)
    let kid = JWKIdentifier(string: options.keyId)
    let payload = ClaimsPayload(exp: exp, iss: iss)
    let signer = try? JWTSigner.es256(key: ECDSAKey.private(pem: key))
    let signedJWT = (try? signer?.sign(payload, kid: kid)) ?? ""
    
    var request = URLRequest(url: endpoint.url)
    request.addValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")
    return request
  }

  private static func sendRequest(_ request: URLRequest) async -> Result<Data, AppStoreConnectError> {
    do {
      let (data, response) = try await URLSession.shared.data(for: request)

      let statusCode = (response as? HTTPURLResponse)?.statusCode
      guard statusCode == 200 else {
        return .failure(.invalidResponse(response))
      }

      return .success(data)
    } catch {
      return .failure(.noDataReceived)
    }
  }

  static func fetch(endpoint: Endpoint, options: Options) async -> Result<Data, AppStoreConnectError> {
    switch key(for: options.keyId) {
    case .failure(let error): return .failure(error)
    case .success(let key):
      let request = createRequest(endpoint: endpoint, key: key, options: options)
      return await sendRequest(request)
    }
  }
}

import ArgumentParser
import Foundation
import JWTKit

struct AppStoreConnect: ParsableCommand {
  enum AppStoreConnectError: Error {
    case cannotWriteProfile
    case invalidResponse(URLResponse?)
    case invalidKeyData
    case keyNotFound
    case noDataReceived
    case undecodableData
  }

  static var configuration = CommandConfiguration(
    commandName: "appstoreconnect",
    abstract: "An interface App Store Connect API",
    subcommands: [Profiles.self, Users.self]
  )

  static var dispatchGroup: DispatchGroup?

  private static func key(for keyId: String) -> Result<Data, AppStoreConnectError> {
    let keyFilePath = "\(FileManager.default.homeDirectoryForCurrentUser.path)/.appstoreconnect/private_keys/AuthKey_\(keyId.uppercased()).p8"
    guard FileManager.default.fileExists(atPath: keyFilePath)
    else { return .failure(.keyNotFound) }

    guard let keyData = FileManager.default.contents(atPath: keyFilePath)
    else { return .failure(.invalidKeyData) }

    return .success(keyData)
  }

  private static func createRequest(endpoint: Endpoint, key: Data, options: Options) -> URLRequest {
    var request = URLRequest(url: endpoint.url)
  
    let signers = JWTSigners()
    try? signers.use(.es256(key: .private(pem: key)))
  
    let exp = ExpirationClaim(value: Date(timeIntervalSinceNow: 3600))
    let iss = IssuerClaim(value: options.issId)
    let claims = ClaimsPayload(exp: exp, iss: iss)
    let kid = JWKIdentifier(string: options.keyId)

    let signedJWT = (try? signers.sign(claims, kid: kid)) ?? ""

    request.addValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")
    return request
  }

  private static func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, AppStoreConnectError>) -> Void) {
    dispatchGroup?.enter()
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      defer {
        dispatchGroup?.leave()
      }

      let statusCode = (response as? HTTPURLResponse)?.statusCode
      guard statusCode == 200 else {
        completion(.failure(.invalidResponse(response)))
        return
      }

      guard let data = data else {
        completion(.failure(.noDataReceived))
        return
      }

      completion(.success(data))
    }
    task.resume()
  }

  static func fetch(endpoint: Endpoint, options: Options, completion: @escaping (Result<Data, AppStoreConnectError>) -> Void) {
    switch key(for: options.keyId) {
    case .failure(let error): completion(.failure(error))
    case .success(let key):
      let request = createRequest(endpoint: endpoint, key: key, options: options)
      sendRequest(request, completion: completion)
    }
  }
}
import ArgumentParser
import Foundation
import SwiftJWT

struct AppStoreConnect: ParsableCommand {
  enum AppStoreConnectError: Error {
    case invalidResponse(URLResponse?)
    case keyNotFound
    case invalidKeyData
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
    let header = Header(typ: "JWT", kid: options.keyId)
    let signer = JWTSigner.es256(privateKey: key)
    let claims = APIClaims(exp: Date(timeIntervalSinceNow: 3600), iss: options.issId)
    var jwt = JWT(header: header, claims: claims)
    let signedJWT = (try? jwt.sign(using: signer)) ?? ""

    var request = URLRequest(url: endpoint.url)
    request.addValue("Bearer \(signedJWT)", forHTTPHeaderField: "Authorization")

    return request
  }

  private static func sendRequest(_ request: URLRequest, completion: @escaping (Result<Data, AppStoreConnectError>) -> Void) {
    AppStoreConnect.dispatchGroup?.enter()
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      defer {
        AppStoreConnect.dispatchGroup?.leave()
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
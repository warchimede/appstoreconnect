import Foundation

enum Endpoint: String {
  private static let base = "https://api.appstoreconnect.apple.com/v1/"

  case profiles, users

  var url: URL { URL(string: "\(Self.base)\(rawValue)?limit=200")! }
}
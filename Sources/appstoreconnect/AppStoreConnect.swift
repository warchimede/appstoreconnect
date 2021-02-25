import ArgumentParser
import Foundation

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
}
import ArgumentParser
import Foundation

struct AppStoreConnect: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "appstoreconnect",
    abstract: "An interface App Store Connect API",
    subcommands: [Profiles.self, Users.self]
  )

  static var dispatchGroup: DispatchGroup?
}
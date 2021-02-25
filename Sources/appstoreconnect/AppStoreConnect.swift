import ArgumentParser
import Foundation

struct AppStoreConnect: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "An interface App Store Connect API",
    subcommands: [Profiles.self, Users.self]
  )
}
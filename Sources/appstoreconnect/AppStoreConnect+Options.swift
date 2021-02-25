import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Options: ParsableArguments {
    @Argument(help: "The key identifier")
    var keyId: String

    @Argument(help: "The issuer identifier")
    var issId: String
  }
}
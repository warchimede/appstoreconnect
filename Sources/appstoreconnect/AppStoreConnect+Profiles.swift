import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Profiles: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Download the provisionning profiles")

    mutating func run() {
      print("Download all the profiles !")
    }
  }
}
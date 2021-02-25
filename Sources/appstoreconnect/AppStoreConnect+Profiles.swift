import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Profiles: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Download the provisioning profiles")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() {
      print("Download all the profiles !")
    }
  }
}
import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Users: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print the users")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() {
      print("Print all the users !")
    }
  }
}
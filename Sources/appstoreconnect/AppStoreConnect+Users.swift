import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Users: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print the users")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() throws {
      AppStoreConnect.fetch(endpoint: .users, options: options) { result in
        switch result {
        case .failure(let error): print("ERROR: \(error)")
        case .success(let data): print(String(data: data, encoding: .utf8) ?? "Error: \(AppStoreConnectError.undecodableData)")
        }
      }
    }
  }
}
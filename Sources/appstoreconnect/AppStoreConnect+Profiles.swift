import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Profiles: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Download the provisioning profiles")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() {
      AppStoreConnect.fetch(endpoint: .profiles, options: options) { result in
        switch result {
        case .failure(let error): print("ERROR: \(error)")
        case .success(let data): print(String(data: data, encoding: .utf8) ?? "Error: \(AppStoreConnectError.undecodableData)")
        }
      }
    }
  }
}
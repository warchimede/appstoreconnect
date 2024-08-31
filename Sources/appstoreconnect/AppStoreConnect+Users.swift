import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Users: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print the users")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() async throws {
      let result = await AppStoreConnect.asyncFetch(endpoint: .users, options: options)

      let output = switch result {
      case .failure(let error): "ERROR: \(error)"
      case .success(let data): String(data: data, encoding: .utf8) ?? "Error: \(AppStoreConnectError.undecodableData)"
      }

      print(output)
    }
  }
}

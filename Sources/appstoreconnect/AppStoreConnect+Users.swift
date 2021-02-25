import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Users: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print the users")

    @OptionGroup var options: AppStoreConnect.Options

    mutating func run() throws {
      guard let key = AppStoreConnect.key(for: options.keyId)
      else {
        print("ERROR Key data")
        return
      }

      let request = AppStoreConnect.request(endpoint: .users, key: key, keyId: options.keyId, issId: options.issId)

      AppStoreConnect.dispatchGroup?.enter()
      URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
        if let error = error {
          print("ERROR RESPONSE \(error)")
          return
        }

        if let result = data.flatMap({ String(data: $0, encoding: .utf8) }) {
          print(result)
        } else {
          print("ERROR NO DATA")
        }
        AppStoreConnect.dispatchGroup?.leave()
      }).resume()
    }
  }
}
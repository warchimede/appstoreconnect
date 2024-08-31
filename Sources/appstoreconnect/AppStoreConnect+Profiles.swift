import ArgumentParser
import Foundation

extension AppStoreConnect {
  struct Profiles: AsyncParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Download and install the provisioning profiles")

    @OptionGroup var options: AppStoreConnect.Options

    private static func write(attributes: Profile.Attributes) throws {
      guard
        let directoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first,
        let fileData = Data(base64Encoded: attributes.profileContent)
      else { throw AppStoreConnectError.cannotWriteProfile }

      let fileName = attributes.name.replacingOccurrences(of: " ", with: "_")
        .appending("_\(attributes.uuid).mobileprovision")
      let fileURL = directoryURL.appendingPathComponent("MobileDevice")
        .appendingPathComponent("Provisioning Profiles")
        .appendingPathComponent(fileName)
      try fileData.write(to: fileURL)
    }

    private static func handleResponse(data: Data) throws {
      try JSONDecoder()
        .decode(Profile.Response.self, from: data)
        .data
        .forEach {
          try write(attributes: $0.attributes)
        }
    }

    mutating func run() async throws {
      let result = await AppStoreConnect.fetch(endpoint: .profiles, options: options)

      switch result {
      case .failure(let error): print("ERROR: \(error)")
      case .success(let data):
        do {
          try Self.handleResponse(data: data)
        } catch {
          print("ERROR: \(error)")
        }
      }
    }
  }
}

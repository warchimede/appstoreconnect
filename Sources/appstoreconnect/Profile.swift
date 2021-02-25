import Foundation

struct Profile: Decodable {
  struct Attributes: Decodable {
    let name: String
    let profileContent: String
    let uuid: String
  }

  struct Response: Decodable {
    let data: [Profile]
  }

  let attributes: Attributes
}
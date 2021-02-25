import Foundation
import SwiftJWT

struct APIClaims: Claims {
  let admin = true
  let aud = "appstoreconnect-v1"
  let exp: Date
  let iss: String
}
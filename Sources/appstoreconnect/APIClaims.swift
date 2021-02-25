import Foundation
import SwiftJWT

struct APIClaims: Claims {
  let aud: String
  let exp: Date
  let isAdmin: Bool
  let iss: String
  let sub: String

  init(aud: String = "appstoreconnect-v1", exp: Date, isAdmin: Bool = true, iss: String, sub: String = "jenkins") {
    self.aud = aud
    self.exp = exp
    self.isAdmin = isAdmin
    self.iss = iss
    self.sub = sub
  }
}
import Foundation
import JWTKit

struct ClaimsPayload: JWTPayload {
  let aud: AudienceClaim
  let exp: ExpirationClaim
  let iss: IssuerClaim

  init(exp: ExpirationClaim, iss: IssuerClaim) {
    self.aud = "appstoreconnect-v1"
    self.exp = exp
    self.iss = iss
  }

  func verify(using signer: JWTKit.JWTSigner) throws {
    try exp.verifyNotExpired()
  }
}
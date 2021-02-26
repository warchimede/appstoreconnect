import Foundation
import JWTKit

struct ClaimsPayload: JWTPayload {
  let aud: AudienceClaim
  let exp: ExpirationClaim
  let admin: Bool
  let iss: IssuerClaim
  let sub: SubjectClaim

  init(aud: AudienceClaim = "appstoreconnect-v1", exp: ExpirationClaim, admin: Bool = true,
    iss: IssuerClaim, sub: SubjectClaim = "jenkins") {
    self.aud = aud
    self.exp = exp
    self.admin = admin
    self.iss = iss
    self.sub = sub
  }

  func verify(using signer: JWTKit.JWTSigner) throws {
    try exp.verifyNotExpired()
  }
}
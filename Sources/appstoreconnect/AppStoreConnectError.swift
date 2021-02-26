import Foundation

enum AppStoreConnectError: Error {
    case cannotWriteProfile
    case invalidResponse(URLResponse?)
    case invalidKeyData
    case keyNotFound
    case noDataReceived
    case undecodableData
  }
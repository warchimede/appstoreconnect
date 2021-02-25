import Foundation

let dispatchGroup = DispatchGroup()

AppStoreConnect.dispatchGroup = dispatchGroup
AppStoreConnect.main()

dispatchGroup.notify(queue: DispatchQueue.main) {
  exit(EXIT_SUCCESS)
}
dispatchMain()
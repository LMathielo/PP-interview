import Foundation

/*
 Json Contract
[
  {
    "id": 1,
    "name": "Shakira",
    "photoURL": "https://picsum.photos/id/237/200/"
  }
]
*/

struct Contact: Codable, Hashable {
    let id: Int
    let name: String
    let photoURL: String
}

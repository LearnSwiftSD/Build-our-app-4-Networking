import UIKit

struct Repository {
  let name: String
  let description: String
  let url: String
  let image: UIImage
  let stars: Int
  let forks: Int
  let watching: Int

//  init(name: String, description: String, url: String, image: UIImage = #imageLiteral(resourceName: "swift"), stars: Int, forks: Int, watching: Int) {
//    self.name = name
//    self.description = description
//    self.url = url
//    self.image = image
//    self.stars = stars
//    self.forks = forks
//    self.watching = watching
//  }
}

extension Repository: Equatable {

  static func ==(lhs: Repository, rhs: Repository) -> Bool {

    guard lhs.name == rhs.name else { return false }
    guard lhs.url == rhs.url else { return false }
    guard lhs.image == rhs.image else { return false }
    guard lhs.stars == rhs.stars else { return false }
    guard lhs.forks == rhs.forks else { return false }
    guard lhs.watching == rhs.watching else { return false }

    return true
  }

}

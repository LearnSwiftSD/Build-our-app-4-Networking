import Foundation
import UIKit
import PlaygroundSupport
//: # Networking

//: ### Our entities

//: ##### Lets just start with one as a sample

struct Repository {
  let id: Int          //id
  let name: String     //name
  let fullName: String //full_name
  let createdAt: String  //created_at
  let updatedAt: String  //updated_at
  let url: String      //url
  let stars: Int       //stars
  let forks: Int       //forks
  let watchers: Int    //watchers
}

//: The JSON response we obtain from the url
//:    GET https://api.github.com/orgs/LearnSwiftSD/repos
//: would look something like
/*:
 [ {
 "id": 92120778,
 "name": "Get-started",
 "stargazers_count": 0,
 "watchers_count": 0,
 "html_url": "https://github.com/LearnSwiftSD/Get-started",
 "forks_count": 0,
 "open_issues_count": 0,
 "forks": 0,
 "watchers": 0,
 },
 {
 "id": 92623619,
 "name": "swift-basics",
 "stargazers_count": 0,
 "watchers_count": 0,
 "html_url": "https://github.com/LearnSwiftSD/swift-basics",
 "forks_count": 0,
 "open_issues_count": 0,
 "forks": 0,
 "watchers": 0
 }, ...
 ]
 */

//: In its most basic form, if we want to create a *GET* request to obtain the list of repositories, we would perform the following. Following the tutorial,
//:     https://www.raywenderlich.com/158106/urlsession-tutorial-getting-started

func getDataFromNetwork(fromUrlString urlString: String, completion: @escaping (Data) -> ()) {

  let url = URL(string: urlString)!

  let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
    if let error = error {
      print("Oh no, something really bad happened!!!")
      dump(error)
      fatalError()
    }

    if
      let data = data,
      let response = response as? HTTPURLResponse {

      if response.statusCode == 200 {

        print("Everything is groovy, lets do stuff with the data")
        completion(data)

      } else {

        print("It looks like there is some kind of other error here. The response object is")
        dump(response)
        print("The data we got back is")
        dump(data)
      }
    }

  }

  dataTask.resume()
}

let url = "https://api.github.com/orgs/LearnSwiftSD/repos"

//getDataFromNetwork(fromUrlString: url) { data in
//  print("The data we get from the network is")
//  print("That isn't too useful, lets turn it into JSON")
//
//  if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//    dump(json)
//  }
//}

//: #### Improvements

//: 1. Use `typealias`

typealias JSONDictionary = [String: Any]

//: 2. Create a Result Type to gracefully handle the response

enum NetworkResult {
  case success(Data)
  case failure(Error)
}

//: 3. Create an Error Type for the different types of errors we might encounter

enum NetworkError: Error {
  case networkRequestError
  case couldNotParseJSON
  case noData
  case invalidResponse
  case unauthorized
  case serverError
  case unknownError
}

// 4. Lets create an enum to describe the different HTTP methods

enum HTTPMethod {
  case get
  case put
  case post
}

//: So an improvement to the method above could be
func improvedGetData(fromURLString urlString: String, completion: @escaping (NetworkResult) -> ()) {

  let url = URL(string: urlString)!

  let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

    if let error = error {
      completion(NetworkResult.failure(error))
    }

    guard let data = data else {
      completion(NetworkResult.failure(NetworkError.noData)); return
    }

    guard let response = response as? HTTPURLResponse else {
      completion(NetworkResult.failure(NetworkError.invalidResponse)); return
    }

    if case 200 ... 299 = response.statusCode {

      completion(NetworkResult.success(data))

    } else {
      completion(NetworkResult.failure(NetworkError.unknownError))
    }

  }

  dataTask.resume()
}

//: We will talk more about error handling in another lesson, but this can serve as an example for setting up an Error enum. Lets make sure it worked
//improvedGetData(fromURLString: url) { result in
//  switch result {
//  case .success(let data):
//    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
//      return
//    }
//    dump(json)
//  case .failure(let error):
//    dump(error)
//  }
//}

//: ### Ok, so now lets make it much better by using protocols and generics

//: We create a type to encapsulate the endpoint information
protocol APIType {
  var baseUrl: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var parameters: JSONDictionary? { get }
  var sampleData: Data { get }
}

//: and start our API description
enum GithubAPI {
  case getRepositories
  case createRepository(name: String)
  ///... add endpoints here

}

//: Add conformance to `APIType`
extension GithubAPI: APIType {
  var baseUrl: String { return "https://api.github.com" }

  var path: String {
    switch self {
    case .getRepositories:
      return "/orgs/LearnSwiftSD/repos"
    case .createRepository:
      return "/orgs/LearnSwiftSD/repos"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .getRepositories:
      return .get
    case .createRepository:
      return .post
    }
  }

  var parameters: JSONDictionary? {
    switch self {
    case .getRepositories:
      return nil
    case .createRepository(let name):
      return [
        "name" : name
      ]
    }
  }

  var sampleData: Data {
    switch self {
    case .getRepositories:
      return Data()
    case .createRepository:
      return Data()
    }
  }
}

//: We also need to be able to initialize our `Repository` object from JSON
protocol JSONInitializable {
  init?(fromJSON json: JSONDictionary)
}
//: This will be replaced with the `Codable` protocol in Swift 4 but for now ¯\_(ツ)_/¯
extension Repository: JSONInitializable {
  init?(fromJSON json: JSONDictionary) {
    guard
      let id = json["id"] as? Int,
      let name = json["name"] as? String,
      let fullName = json["full_name"] as? String,
      let createdAt = json["created_at"] as? String,
      let updatedAt = json["updated_at"] as? String,
      let url = json["url"] as? String,
      let stars = json["stargazers_count"] as? Int,
      let forks = json["forks"] as? Int,
      let watchers = json["watchers_count"] as? Int else { print("Error parsing"); return nil }

    self.id = id
    self.name = name
    self.fullName = fullName
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.url = url
    self.stars = stars
    self.forks = forks
    self.watchers = watchers
  }
}
//: Now we can create a generic `request` method and encapsulate the functionality in a protocol
protocol NetworkClientType {
  func request<A>(endpoint: APIType, completion: @escaping (Result<A>) -> ())
}

//: We will need a more generic `Result` type
enum Result<A> {
  case success(A)
  case failure(Error)
}
//: and lets move our networking code inside of that.
final class NetworkClient: NetworkClientType {
  func request<A>(endpoint: APIType, completion: @escaping (Result<A>) -> ()) {

    let urlString = endpoint.baseUrl + endpoint.path
    let url = URL(string: urlString)!

    let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in

      if let error = error {
        completion(Result.failure(error))
      }

      guard let data = data else {
        completion(Result.failure(NetworkError.noData)); return
      }

      guard let response = response as? HTTPURLResponse else {
        completion(Result.failure(NetworkError.invalidResponse)); return
      }

      if case 200 ... 299 = response.statusCode {

        // Now we need to parse the data
        let obj = try! JSONSerialization.jsonObject(with: data, options: []) as! A
        completion(Result.success(obj))

      } else {
        completion(Result.failure(NetworkError.unknownError))
      }

    }

    dataTask.resume()

  }
}
//: Lets see if we can view it in the list
class RepositoryListViewController: UITableViewController {

  var repositories: [Repository] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    //    let client = NetworkClient()
    //
    //    client.request(endpoint: GithubAPI.getRepositories) { (result: Result<[JSONDictionary]>) -> Void in
    //      if case .success(let jsonArray) = result {
    //        //    dump(jsonArray)
    //
    //        self.repositories = jsonArray.flatMap(Repository.init)
    //
    //        print("We have \(self.repositories.count) respositories")
    //      }
    //    }

  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!

    let repository = repositories[indexPath.row]

    cell.textLabel?.text = repository.name

    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
  
}

let repositoryListVC = RepositoryListViewController(style: .plain)

PlaygroundPage.current.liveView = repositoryListVC.view
//PlaygroundPage.current.needsIndefiniteExecution = true

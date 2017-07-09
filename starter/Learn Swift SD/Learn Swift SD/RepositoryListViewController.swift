import UIKit

class RepositoryListViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var repositoryTableView: UITableView!

  // MARK: Model
  var repositories: [Repository] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    repositoryTableView.delegate = self
    repositoryTableView.dataSource = self
    repositories = FakeData.repositories

  }

}

extension RepositoryListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    guard let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as? RepositoryTableViewCell else {
      fatalError("Could not cast as RepositoryTableViewCell")
    }

    let repository = repositories[indexPath.row]

    cell.configure(withRepository: repository)

    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return repositories.count
  }
}

extension RepositoryListViewController: UITableViewDelegate {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedRepository = repositories[indexPath.row]

		let repositoryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "repositoryDetail") as! RepositoryDetailViewController

		repositoryDetailViewController.repository = selectedRepository
//		self.navigationController?.pushViewController(repositoryDetailViewController, animated: true)

		self.present(repositoryDetailViewController, animated: true, completion: nil)
	}
}

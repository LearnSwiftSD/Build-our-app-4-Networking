import UIKit
import PlaygroundSupport

class RepositoryDetailViewController: UIViewController {
  let rootStackView = UIStackView()
  let topHorizontalStackView = UIStackView()
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()
  let watchButton = UIButton()
  let starButton = UIButton()
  let forkButton = UIButton()
  let topLeftStackView = UIStackView()
  let topRightStackView = UIStackView()
  let tableView = UITableView()

  override func viewDidLoad() {
    rootStackView.translatesAutoresizingMaskIntoConstraints = false
    rootStackView.axis = .vertical
    rootStackView.spacing = 8

    view.backgroundColor = .white

    view.addSubview(rootStackView)
    rootStackView.addArrangedSubview(topHorizontalStackView)
    titleLabel.text = "Build our app 1"
    titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, compatibleWith: self.traitCollection)
    topHorizontalStackView.addArrangedSubview(titleLabel)
  }
}

//let vc = RepositoryDetailViewController()
//PlaygroundPage.current.liveView = vc


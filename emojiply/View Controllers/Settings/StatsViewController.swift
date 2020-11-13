import Foundation
import UIKit

final class StatsViewController: UITableViewController {
  private lazy var dataSource = StatsViewControllerDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = dataSource
    title = .title
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if dataSource.isEmpty {
      tableView.setEmptyView(message: .noStats)
      title = .emptyTitle
    }
  }
}

fileprivate extension String {
  static let title = NSLocalizedString("screen.title.stats", comment: "Title for the Stats screen")
  static let emptyTitle = NSLocalizedString("screen.title.stats.empty", comment: "Title for the Stats screen when there are no stats")

  static let noStats = NSLocalizedString("screen.stats.empty", comment: "Label that informs the user this section will be populated over time")
}

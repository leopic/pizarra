import Foundation
import UIKit

final class StatsViewController: UITableViewController {
  public var days = [Day]()

  private lazy var dataSource = StatsViewControllerDataSource(days: days)

  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = dataSource
    title = LocalizedStrings.Screen.Title.stats
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
}

fileprivate extension String {
  static let title = NSLocalizedString("screen.title.stats", comment: "Title for the Stats screen")
}

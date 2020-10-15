import Foundation
import UIKit

final class SettingsController: UITableViewController {
  private let dataSource = SettingsControllerDataSource()

  override func viewDidLoad() {
    super.viewDidLoad()

    title = .title
    tableView.dataSource = dataSource
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard indexPath.section == SettingsControllerDataSource.Section.misc else { return }

    switch indexPath.row {
    case 0:
      performSegue(withIdentifier: .showPreviousDays, sender: self)
    case 1:
      performSegue(withIdentifier: .showFAQ, sender: self)
    default:
      break
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch (segue.identifier, segue.destination) {
    case (.showPreviousDays?, let previousDays as StatsViewController):
      previousDays.days = Logger.shared.getAll()
    case (.showFAQ?, _):
      print("FAQ!")
    default:
      break
    }
  }

  @objc private func doneTapped() -> Void {
    dismiss(animated: true, completion: nil)
  }
}

fileprivate extension String {
  static let title = NSLocalizedString("screen.title.settings", comment: "Title for the Settings screen")
  
  static let showPreviousDays = "showPreviousDays"
  static let showFAQ = "showFAQ"
}

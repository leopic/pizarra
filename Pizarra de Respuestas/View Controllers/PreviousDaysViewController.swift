import Foundation
import UIKit

final class PreviousDaysViewController: UITableViewController {
  public var days = [Day]()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "The last \(days.count) days"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    days.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    days[section].events.count
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let date = days[section].date {
      return "Answers for: \(date)"
    }

    return nil
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    "Total Answers \(days[section].events.count)"
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
    let day = days[indexPath.section]
    let answer = day.events[indexPath.row]
    cell.textLabel?.text = answer.description

    return cell
  }
}

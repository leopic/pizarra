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
    1
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let date = days[section].date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .long
      dateFormatter.timeStyle = .none
      return dateFormatter.string(from: date)
    }

    return nil
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    "Total: \(days[section].events.count)"
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
    let day = days[indexPath.section]
    cell.textLabel?.text = day.events.map { $0.value }.joined(separator: ", ")
    cell.textLabel?.font = Fonts.title2

    return cell
  }
}

import Foundation
import UIKit

final class PreviousDaysViewController: UITableViewController {
  public var days = [Day]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = LocalizedStrings.Screen.Title.stats
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    days.count + 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 1 : 1
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section > 0 else {
      return LocalizedStrings.StatsScreen.summary
    }

    guard let date = days[section - 1].date else { return nil }

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    return dateFormatter.string(from: date)
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    section == 0 ? nil : "\(LocalizedStrings.StatsScreen.total): \(days[section - 1].events.count)"
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as! SummaryCell
      cell.summary = Summary(days: days)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as! DayCell
      cell.day = days[indexPath.section - 1]
      return cell
    }
  }
}

import Foundation
import UIKit

final class StatsViewControllerDataSource: NSObject, UITableViewDataSource {
  private var days = [Day]()

  enum Sections: Int {
    case summary = 0
    case detail = 1

    static func ==(lhs: Int, rhs: Sections) -> Bool {
      lhs == rhs.rawValue
    }

    static func ==(lhs: Sections, rhs: Int) -> Bool {
      lhs.rawValue == rhs
    }
  }

  init(days: [Day]) {
    super.init()
    self.days = days
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == Sections.summary ? 1 : 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == Sections.summary {
      let cell = tableView.dequeueReusableCell(withIdentifier: SummaryCell.identifier, for: indexPath) as! SummaryCell
      cell.summary = Summary(days: days)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: DayCell.identifier, for: indexPath) as! DayCell
      cell.day = days[indexPath.section - 1]
      return cell
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    days.count + 1
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard section != StatsViewControllerDataSource.Sections.summary.rawValue else {
      return nil
    }

    return "\(LocalizedStrings.StatsScreen.total): \(days[section - 1].events.count)"
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section != StatsViewControllerDataSource.Sections.summary.rawValue else {
      return LocalizedStrings.StatsScreen.summary
    }

    guard let date = days[section - 1].date else { return nil }

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none
    return dateFormatter.string(from: date)
  }
}

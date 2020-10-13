import Foundation
import UIKit

final class StatsViewControllerDataSource: NSObject, UITableViewDataSource {
  enum Section: Int {
    case summary = 0
    case detail = 1

    static func ==(lhs: Int, rhs: Section) -> Bool {
      lhs == rhs.rawValue
    }
  }

  private var days = [Day]()

  init(days: [Day]) {
    super.init()
    self.days = days
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == .summary ? 1 : 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      return UITableViewCell()
    }

    switch section {
    case .summary:
      let cell = tableView.dequeueReusableCell(withIdentifier: SummaryCell.identifier, for: indexPath) as! SummaryCell
      cell.summary = Summary(days: days)
      return cell
    case .detail:
      let cell = tableView.dequeueReusableCell(withIdentifier: DayCell.identifier, for: indexPath) as! DayCell
      cell.day = days[indexPath.section - 1]
      return cell
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    days.count + 1
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    section == .detail ? String.total(days[section - 1].events.count) : nil
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section == .detail else { return .summary }

    guard let date = days[section - 1].date else { return nil }

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .full
    dateFormatter.timeStyle = .none

    return dateFormatter.string(from: date)
  }
}

private extension String {
  static let stats = NSLocalizedString("screen.title.stats", comment: "Title for the Stats screen")
  static let summary = NSLocalizedString("screen.stats.summary", comment: "Summary header")
  static func total(_ number: Int) -> String {
    let format = NSLocalizedString("screen.stats.total", comment: "Total label")
    return String.localizedStringWithFormat(format, number)
  }
}

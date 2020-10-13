import Foundation
import UIKit

final class SettingsControllerDataSource: NSObject, UITableViewDataSource {
  enum Section: Int, CaseIterable {
    case feedbackOptions = 0
    case misc = 1

    static func ==(lhs: Int, rhs: Section) -> Bool {
      lhs == rhs.rawValue
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == .feedbackOptions ? 2 : 1
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    section == .feedbackOptions ? .feedbackOptions : nil
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = Section(rawValue: indexPath.section) else {
      return UITableViewCell()
    }

    switch section {
    case .feedbackOptions:
      let switchCell = tableView.dequeueReusableCell(withIdentifier: SwitchCell.identifier, for: indexPath) as! SwitchCell
      switchCell.setting = indexPath.row == 0 ? .sound : .vibration
      return switchCell
    case .misc:
      let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
      historyCell.accessoryType = .disclosureIndicator

      switch indexPath.row {
      case 0:
        historyCell.textLabel?.text = .stats
      case 1:
        historyCell.textLabel?.text = .faq
      default:
        historyCell.textLabel?.text = .acknowledgments
      }

      return historyCell
    }
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard section == .misc,
          let appInfo = Bundle.main.infoDictionary,
          let shortVersionString = appInfo["CFBundleShortVersionString"] as? String else {
      return nil
    }

    return String.appVersion(shortVersionString)
  }
}

fileprivate extension String {
  static let feedbackOptions = NSLocalizedString("screen.settings.feedback.options", comment: "Feedback Options label")

  static let stats = NSLocalizedString("screen.settings.stats", comment: "Stats label")
  static let faq = NSLocalizedString("screen.settings.faq", comment: "FAQ label")
  static let acknowledgments = NSLocalizedString("screen.settings.acknowledgments", comment: "Acknowledgments label")

  static func appVersion(_ number: String) -> String {
    let format = NSLocalizedString("screen.settings.app.version", comment: "App version label")
    return String.localizedStringWithFormat(format, number)
  }
}

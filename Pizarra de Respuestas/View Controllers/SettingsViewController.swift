import Foundation
import UIKit

final class SettingsController: UITableViewController {
  private var settings = UserPreferences()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = LocalizedStrings.Screen.Title.settings
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    LocalizedStrings.SettingsScreen.feedbackOptions
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! SwitchCell


    if indexPath.row == 0 {
      cell.setting = .sound
    }

    if indexPath.row == 1 {
      cell.setting = .vibration
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    guard let appInfo = Bundle.main.infoDictionary,
          let shortVersionString = appInfo["CFBundleShortVersionString"] as? String else {
      return nil
    }

    return "\(LocalizedStrings.SettingsScreen.appVersion) \(shortVersionString)"
  }

  @objc private func doneTapped() -> Void {
    dismiss(animated: true, completion: nil)
  }
}

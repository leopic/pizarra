import Foundation
import UIKit

final class SettingsController: UITableViewController {
  private var settings = UserPreferences()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Settings"
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    "Feedback Options"
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()


    if indexPath.row == 0 {
      cell.textLabel?.text = "Vibration Enabled: \(settings.isVibrationEnabled)"
    }

    if indexPath.row == 1 {
      cell.textLabel?.text = "Sound enabled: \(settings.isSoundEnabled)"
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)

    if indexPath.row == 0 {
      settings.isVibrationEnabled.toggle()
    }

    if indexPath.row == 1 {
      settings.isSoundEnabled.toggle()
    }

    tableView.reloadData()
  }

  @objc private func doneTapped() -> Void {
    dismiss(animated: true, completion: nil)
  }
}

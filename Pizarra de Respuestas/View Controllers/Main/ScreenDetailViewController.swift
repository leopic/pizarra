import UIKit

final class ScreenDetailViewController: UITableViewController {
  public var screen: Screen!

  private var selectedOptionIndex: Int?

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    screen.options.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let optionCell = tableView.dequeueReusableCell(withIdentifier: CellReuseId.optionCell) as! OptionCell
    optionCell.option = screen.options[indexPath.row]
    return optionCell
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.backgroundColor = Color.blackboard
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewOption))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == .showOptionForm,
      let destination = segue.destination as? OptionFormViewController else { return }

    destination.screen = screen
    destination.index = selectedOptionIndex
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedOptionIndex = indexPath.row
    showOptionForm()
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    let ac = UIAlertController(title: .confirmDeletion, message: nil, preferredStyle: .alert)

    ac.addAction(UIAlertAction(title: .delete, style: .destructive, handler: {
      [unowned self]  action in

      self.screen.options.remove(at: indexPath.row)

      ScreenStore.shared.update(screen) { [weak self] result in
        guard let self = self else { return }

        switch result {
        case .success(_):
          self.tableView.deleteRows(at: [indexPath], with: .fade)
        case .failure(let error):
          print("error!", error)
        }
      }
    }))

    ac.addAction(UIAlertAction(title: .cancel, style: .cancel))

    present(ac, animated: true)
  }

  @objc private func addNewOption() -> Void {
    selectedOptionIndex = nil
    showOptionForm()
  }

  private func showOptionForm() -> Void {
    performSegue(withIdentifier: .showOptionForm, sender: self)
  }

  private func save() -> Void {
    ScreenStore.shared.update(screen) { [weak self] result in
      guard let self = self else { return }

      switch result {
      case .success(_):
        self.navigationController?.popViewController(animated: true)
      case .failure(let error):
        print("error!", error)
      }
    }
  }
}

private extension String {
  static let cancel = LocalizedStrings.General.Button.cancel
  static let delete = LocalizedStrings.General.Button.delete
  static let confirmDeletion = LocalizedStrings.Alert.Title.confirmDeletion

  static let showOptionForm = "showOptionForm"
}

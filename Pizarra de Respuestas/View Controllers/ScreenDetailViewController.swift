import UIKit

final class ScreenDetailViewController: UITableViewController {
  public var screen: Screen!
  public var selectedOptionIndex: Int?

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
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToTheThing))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    tableView.reloadData()
    guard screen.shouldTrackEvents else { return }
    Logger.track.screen("Screen Detail")
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == SegueId.showOptionForm,
      let destination = segue.destination as? OptionFormViewController else { return }

    destination.screen = screen
    destination.index = selectedOptionIndex
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedOptionIndex = indexPath.section == 0 ? indexPath.row : nil
    goToTheThing()
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }

    let ac = UIAlertController(title: LocalizedStrings.Alert.Title.confirmDeletion, message: nil, preferredStyle: .alert)

    ac.addAction(UIAlertAction(title: LocalizedStrings.General.Button.delete, style: .destructive, handler: {
      [unowned self]  action in
      self.screen.options.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .fade)
    }))

    ac.addAction(UIAlertAction(title: LocalizedStrings.General.Button.cancel, style: .cancel))

    present(ac, animated: true)
  }

  @objc private func goToTheThing() -> Void {
    performSegue(withIdentifier: SegueId.showOptionForm, sender: self)
  }
}

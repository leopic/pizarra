import UIKit

class ScreenDetailViewController: UITableViewController {
  enum Section: Int, CaseIterable {
    case add = 0
    case options = 1
  }

  var screen: Screen!
  var selectedOptionIndex: Int?

  override func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section(rawValue: section) {
    case .add:
      return 1
    case .options:
      return screen.options.count
    default:
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()

    switch Section(rawValue: indexPath.section) {
    case .add:
      cell = tableView.dequeueReusableCell(withIdentifier: CellReuseId.addCell)!
      cell.tintColor = UIColor.systemBlue
    case .options:
      let optionCell = tableView.dequeueReusableCell(withIdentifier: CellReuseId.optionCell) as! OptionCell
      optionCell.option = screen.options[indexPath.row]
      cell = optionCell
    default:
      return cell
    }

    return cell
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = Color.blackboard
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == SegueId.showOptionForm,
      let destination = segue.destination as? OptionFormViewController else { return }

    destination.screen = screen
    destination.index = selectedOptionIndex
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedOptionIndex = indexPath.section == 1 ? indexPath.row : nil
    performSegue(withIdentifier: SegueId.showOptionForm, sender: self)
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
}

import UIKit

class ScreenDetailViewController: UITableViewController {
  enum Section: Int, CaseIterable {
    case add = 0
    case options = 1
  }

  var screen: AScreen!

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
      cell = tableView.dequeueReusableCell(withIdentifier: "addCell")!
      cell.tintColor = UIColor.systemBlue
    case .options:
      let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionCell
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

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard screen.options.count < 8 else { return }

    screen.options.append(Option(label: "🍺", destination: nil, backgroundColor: .green))
    tableView.insertRows(at: [IndexPath(row: screen.options.count - 1, section: Section.options.rawValue)], with: .fade)
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    screen.options.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .fade)
  }
}

class OptionCell: UITableViewCell {
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var color: UIView!

  var option: Option! {
    didSet {
      label.text = option.label
      color.backgroundColor = option.backgroundColor?.withAlphaComponent(0.5) ?? UIColor.clear
      color.layer.cornerRadius = 8
      color.layer.borderColor = Color.label.withAlphaComponent(0.25).cgColor
      color.layer.borderWidth = 1
    }
  }
}

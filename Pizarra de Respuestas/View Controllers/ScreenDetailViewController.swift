import UIKit

class ScreenDetailViewController: UITableViewController {
  var screen: AScreen!

  override func numberOfSections(in tableView: UITableView) -> Int {
    2
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    section == 0 ? 1 : screen.options.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()

    switch indexPath.section {
    case 0:
      cell = tableView.dequeueReusableCell(withIdentifier: "addCell")!
    case 1:
      let optionCell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionCell
      optionCell.option = screen.options[indexPath.row]
      cell = optionCell
    default:
      return cell
    }

    return cell
  }

  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    section == 0 ? nil : "Total: \(screen.options.count)"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.backgroundColor = Color.blackboard
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    screen.options.append(Option(label: "🍺", destination: nil, backgroundColor: .green))
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

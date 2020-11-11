import UIKit

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

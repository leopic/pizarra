import Foundation
import UIKit

final class SummaryCell: UITableViewCell {
  @IBOutlet weak var stackView: UIStackView!

  public var summary: Summary! {
    didSet {
      stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

      let topAnswers = setupLabel(value: summary.top(3, joinedBy: "  "), key: LocalizedStrings.StatsScreen.mostUsed)
      let daysUsing = setupLabel(value: summary.totalDays, key: LocalizedStrings.StatsScreen.daysUsing)
      let uniqueAnswers = setupLabel(value: summary.unique, key: LocalizedStrings.StatsScreen.uniqueAnswers)

      stackView.addArrangedSubview(topAnswers)
      stackView.addArrangedSubview(daysUsing)
      stackView.addArrangedSubview(uniqueAnswers)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
  }

  private func setupLabel(value: String, key: String) -> UILabel {
    let valueStyles: [NSAttributedString.Key: Any] = [
      .font: Fonts.largeTitle
    ]

    let keyStyles: [NSAttributedString.Key: Any] = [
      .font: Fonts.title3,
      .foregroundColor: Color.label.withAlphaComponent(0.80)
    ]

    let label = UILabel()
    let value = NSMutableAttributedString(string: "\(value)\n", attributes: valueStyles)
    let key = NSAttributedString(string: key, attributes: keyStyles)
    value.append(key)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.attributedText = value

    return label
  }
}

import Foundation
import UIKit

final class SummaryCell: UITableViewCell {
  @IBOutlet weak var stackView: UIStackView!

  public static let identifier = "summaryCell"

  public var summary: Summary! {
    didSet {
      guard !summary.isEmpty else { return }

      stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

      let topAnswers = setupLabel(value: summary.top(3, joinedBy: "  "), key: .mostUsed)
      let daysUsing = setupLabel(value: summary.totalDays, key: .daysUsing)
      let uniqueAnswers = setupLabel(value: summary.unique, key: .uniqueAnswers)

      stackView.addArrangedSubview(topAnswers)
      stackView.addArrangedSubview(daysUsing)
      stackView.addArrangedSubview(uniqueAnswers)
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    stackView.axis = UIDevice.current.userInterfaceIdiom == .pad ? .horizontal : .vertical
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

private extension String {
  static let mostUsed = NSLocalizedString("screen.stats.most.used.answers", comment: "Most used answers label")
  static let daysUsing = NSLocalizedString("screen.stats.days.using.app", comment: "Days using the app label")
  static let uniqueAnswers = NSLocalizedString("screen.stats.unique.answers", comment: "Different answers label")
}

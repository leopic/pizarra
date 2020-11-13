import Foundation
import ColorCompatibility
import UIKit

struct EmptyTableViewConfiguration {
  struct Button {
    var title: String
    var selector: Selector
  }

  var title: String?
  var message: String
  var button: Button?
  var hideRefreshControl = false
}

extension UITableView {
  private func setupMessageLabel(message: String) -> UILabel {
    let messageLabel = UILabel()
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.font = Fonts.title3
    messageLabel.text = message
    messageLabel.textAlignment = .center
    messageLabel.numberOfLines = 0

    return messageLabel
  }

  private func setupTitleLabel(title: String?) -> UILabel {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = Fonts.title2
    titleLabel.text = title

    return titleLabel
  }

  private func setupButton(button: EmptyTableViewConfiguration.Button?) -> UIButton? {
    guard let button = button else {
      return nil
    }

    let aButton = UIButton()
    aButton.translatesAutoresizingMaskIntoConstraints = false
    aButton.setTitle(button.title, for: .normal)
    aButton.setTitleColor(Color.primary, for: .normal)
    aButton.setTitleColor(ColorCompatibility.systemGray2, for: .selected)
    aButton.addTarget(nil, action: button.selector, for: .touchUpInside)

    return aButton
  }

  func setEmptyView(message: String) {
    let config = EmptyTableViewConfiguration(message: message)
    setEmptyView(config: config)
  }

  func setEmptyView(config: EmptyTableViewConfiguration) {
    let emptyView = UIView(frame: CGRect(x: center.x, y: center.y, width: bounds.size.width, height: bounds.size.height))

    let titleLabel = setupTitleLabel(title: config.title)
    emptyView.addSubview(titleLabel)

    let messageLabel = setupMessageLabel(message: config.message)
    emptyView.addSubview(messageLabel)

    let button = setupButton(button: config.button)
    if let configButton = button {
      emptyView.addSubview(configButton)
    }

    setConstraints(titleLabel: titleLabel, messageLabel: messageLabel, emptyView: emptyView, button: button)

    backgroundView = emptyView
    refreshControl?.alpha = config.hideRefreshControl ? 0 : 1
    separatorStyle = .none
  }

  private func setConstraints(titleLabel: UILabel, messageLabel: UILabel, emptyView: UIView, button: UIButton? = nil) {
    let standardSpace: CGFloat = 16

    titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardSpace).isActive = true
    messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: standardSpace).isActive = true
    messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -standardSpace).isActive = true

    if let button = button {
      button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: standardSpace).isActive = true
      button.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: standardSpace).isActive = true
      button.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -standardSpace).isActive = true
    }
  }

  func restore() {
    refreshControl?.alpha = 1
    backgroundView = nil
    separatorStyle = .singleLine
  }
}

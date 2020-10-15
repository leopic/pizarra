import Foundation
import UIKit

final class FAQViewController: UITableViewController {
  struct Entry {
    var question: String
    var answer: String
  }

  private var entries: [Entry] {
    return [
      Entry(question: .userQuestion, answer: .userAnswer),
      Entry(question: .therapyQuestion, answer: .therapyAnswer),
      Entry(question: .emojisQuestion, answer: .emojisAnswer),
      Entry(question: .privacyQuestion, answer: .privacyAnswer),
      Entry(question: .statsQuestion, answer: .statsAnswer),
      Entry(question: .priceQuestion, answer: .priceAnswer),
      Entry(question: .ideaQuestion, answer: .ideaAnswer)
    ]
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = .title
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    2
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    entries.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let entry = entries[indexPath.section]
    let isQuestion = indexPath.row == 0
    let cell = tableView.dequeueReusableCell(withIdentifier: isQuestion ? .questionCell : .answerCell, for: indexPath)
    cell.textLabel?.font = isQuestion ? Fonts.title3 : Fonts.headline
    cell.textLabel?.text = isQuestion ? entry.question : entry.answer

    return cell
  }
}

private extension String {
  static let title = "FAQ"

  static let userQuestion = NSLocalizedString("screen.faq.users.question", comment: "Users question")
  static let userAnswer = NSLocalizedString("screen.faq.users.answer", comment: "Users answer")

  static let therapyQuestion = NSLocalizedString("screen.faq.therapy.question", comment: "Therapy question")
  static let therapyAnswer = NSLocalizedString("screen.faq.therapy.answer", comment: "Therapy answer")

  static let emojisQuestion = NSLocalizedString("screen.faq.emojis.question", comment: "Emojis question")
  static let emojisAnswer = NSLocalizedString("screen.faq.emojis.answer", comment: "Emojis answer")

  static let privacyQuestion = NSLocalizedString("screen.faq.privacy.question", comment: "Privacy question")
  static let privacyAnswer = NSLocalizedString("screen.faq.privacy.answer", comment: "Privacy answer")

  static let statsQuestion = NSLocalizedString("screen.faq.stats.question", comment: "Stats question")
  static let statsAnswer = NSLocalizedString("screen.faq.stats.answer", comment: "Stats answer")

  static let priceQuestion = NSLocalizedString("screen.faq.price.question", comment: "Price question")
  static let priceAnswer = NSLocalizedString("screen.faq.price.answer", comment: "Price answer")

  static let ideaQuestion = NSLocalizedString("screen.faq.idea.question", comment: "Idea question")
  static let ideaAnswer = NSLocalizedString("screen.faq.idea.answer", comment: "Idea answer")

  static let questionCell = "questionCell"
  static let answerCell = "answerCell"
}

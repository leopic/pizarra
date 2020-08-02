import Foundation

final class ScreenFactory {
  class func build(id: Screen.Id) -> Screen {
    switch id {
    case .home:
      let binary = Option(label: "👍 👎\nSi / No", destination: (screen: .binarySelection, segueId: "showDetail"))
      let mood = Option(label: "😀 🙁\nÁnimo", destination: (screen: .moodSelection, segueId: "showDetail"))
      let pain = Option(label: "🤕\nDolor", destination: (screen: .status, segueId: "showDetail"))
      let ambience = Option(label: "🔊 🔇\nAmbiente", destination: (screen: .ambience, segueId: "showDetail"))

      return Screen(title: "Inicio", id: .home, options: [binary, mood, pain, ambience])
    case .binarySelection:
      let positive = Option(label: "👍", backgroundColor: .systemGreen)
      let negative = Option(label: "👎", backgroundColor: .systemRed)
      return Screen(title: "Si / No", id: .binarySelection, options: [positive, negative], canUpdateOptions: true)
    case .moodSelection:
      let positiveMood = Option(label: "😀", destination: (screen: .positiveMood, segueId: "showDetail"), backgroundColor: .systemYellow)
      let negativeMood = Option(label: "🙁", destination: (screen: .negativeMood, segueId: "showDetail"), backgroundColor: .systemBlue)
      return Screen(title: "Ánimo", id: .moodSelection, options: [positiveMood, negativeMood])
    case .positiveMood:
      let options = ["😀", "✌️", "💪", "💓"].map { Option(label: $0) }
      return Screen(title: "Ánimo", id: .positiveMood, options: options, canUpdateOptions: true)
    case .negativeMood:
      let options = ["😭", "😩", "😡", "❤️"].map { Option(label: $0) }
      return Screen(title: "Ánimo", id: .negativeMood, options: options, canUpdateOptions: true)
    case .status:
      let options = ["1️⃣🤕", "2️⃣🙁", "3️⃣😶", "4️⃣🙂", "5️⃣👌"].map { Option(label: $0) }
      return Screen(title: "Dolor", id: .status, options: options, canUpdateOptions: true)
    case .ambience:
      let options = ["🔊", "🔇"].map { Option(label: $0) }
      return Screen(title: "Ambiente", id: .ambience, options: options, canUpdateOptions: true)
    }
  }
}

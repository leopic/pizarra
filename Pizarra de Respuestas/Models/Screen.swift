import UIKit

enum Screen {
  case home
  case binarySelection
  case moodSelection
  case positiveMood
  case negativeMood
  case status
  case ambience

  var title: String {
    switch self {
    case .home:
      return "Inicio"
    case .binarySelection:
      return "Si / No"
    case .positiveMood,
         .negativeMood,
         .moodSelection:
      return "Ánimo"
    case .status:
      return "Dolor"
    case .ambience:
      return "Ambiente"
    }
  }

  var options: [Option] {
    switch self {
    case .home:
      let binary = Option(label: "👍 👎\nSi / No", destination: (screen: .binarySelection, segueId: "showDetail"))
      let mood = Option(label: "😀 🙁\nÁnimo", destination: (screen: .moodSelection, segueId: "showDetail"))
      let pain = Option(label: "🤕\nDolor", destination: (screen: .status, segueId: "showDetail"))
      let ambience = Option(label: "🔊 🔇\nAmbiente", destination: (screen: .ambience, segueId: "showDetail"))

      return [binary, mood, pain, ambience]
    case .binarySelection:
      return [Option(label: "👍", backgroundColor: .green), Option(label: "👎", backgroundColor: .red)]
    case .moodSelection:
      let positiveMood = Option(label: "😀", destination: (screen: .positiveMood, segueId: "showDetail"), backgroundColor: .yellow)
      let negativeMood = Option(label: "🙁", destination: (screen: .negativeMood, segueId: "showDetail"), backgroundColor: .blue)
      
      return [positiveMood, negativeMood]
    case .positiveMood:
      return ["😀", "✌️", "💪", "💓"].map { Option(label: $0) }
    case .negativeMood:
      return ["😭", "😩", "😡", "❤️"].map { Option(label: $0) }
    case .status:
      return ["1️⃣🤕", "2️⃣🙁", "3️⃣😶", "4️⃣🙂", "5️⃣👌"].map { Option(label: $0) }
    case .ambience:
      return ["🔊", "🔇"].map { Option(label: $0) }
    }
  }

  var canUpdateOptions: Bool {
    false
  }
}

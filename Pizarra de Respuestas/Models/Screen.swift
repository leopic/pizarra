import UIKit

enum ScreenId {
  case home
  case binarySelection
  case moodSelection
  case positiveMood
  case negativeMood
  case status
  case ambience
}

class AScreen {
  var title: String
  var options: [Option]
  var canUpdateOptions: Bool
  var id: ScreenId

  init(title: String, id: ScreenId, options: [Option], canUpdateOptions: Bool = false) {
    self.title = title
    self.id = id
    self.options = options
    self.canUpdateOptions = canUpdateOptions
  }
}

class ScreenFactory {
  class func build(id: ScreenId) -> AScreen? {
    switch id {
    case .home:
      let binary = Option(label: "👍 👎\nSi / No", destination: (screen: .binarySelection, segueId: "showDetail"))
      let mood = Option(label: "😀 🙁\nÁnimo", destination: (screen: .moodSelection, segueId: "showDetail"))
      let pain = Option(label: "🤕\nDolor", destination: (screen: .status, segueId: "showDetail"))
      let ambience = Option(label: "🔊 🔇\nAmbiente", destination: (screen: .ambience, segueId: "showDetail"))

      return AScreen(title: "Inicio", id: .home, options: [binary, mood, pain, ambience], canUpdateOptions: true)
//    case binarySelection:
//    case moodSelection:
//    case positiveMood:
//    case negativeMood:
//    case status:
//    case ambience:
    default:
      print("wah wah wah")
    }

    return nil
  }
}

//enum Screen {
//  case home
//  case binarySelection
//  case moodSelection
//  case positiveMood
//  case negativeMood
//  case status
//  case ambience
//
//  var title: String {
//    switch self {
//    case .home:
//      return "Inicio"
//    case .binarySelection:
//      return "Si / No"
//    case .positiveMood,
//         .negativeMood,
//         .moodSelection:
//      return "Ánimo"
//    case .status:
//      return "Dolor"
//    case .ambience:
//      return "Ambiente"
//    }
//  }
//
//  var options: [Option] {
//    switch self {
//    case .home:
////      let binary = Option(label: "👍 👎\nSi / No", destination: (screen: .binarySelection, segueId: "showDetail"))
////      let mood = Option(label: "😀 🙁\nÁnimo", destination: (screen: .moodSelection, segueId: "showDetail"))
////      let pain = Option(label: "🤕\nDolor", destination: (screen: .status, segueId: "showDetail"))
////      let ambience = Option(label: "🔊 🔇\nAmbiente", destination: (screen: .ambience, segueId: "showDetail"))
////
////      return [binary, mood, pain, ambience]
//      return []
//    case .binarySelection:
//      return [Option(label: "👍", backgroundColor: .green), Option(label: "👎", backgroundColor: .red)]
//    case .moodSelection:
//      let positiveMood = Option(label: "😀", destination: (screen: .positiveMood, segueId: "showDetail"), backgroundColor: .yellow)
//      let negativeMood = Option(label: "🙁", destination: (screen: .negativeMood, segueId: "showDetail"), backgroundColor: .blue)
//      
//      return [positiveMood, negativeMood]
//    case .positiveMood:
//      return ["😀", "✌️", "💪", "💓"].map { Option(label: $0) }
//    case .negativeMood:
//      return ["😭", "😩", "😡", "❤️"].map { Option(label: $0) }
//    case .status:
//      return ["1️⃣🤕", "2️⃣🙁", "3️⃣😶", "4️⃣🙂", "5️⃣👌"].map { Option(label: $0) }
//    case .ambience:
//      return ["🔊", "🔇"].map { Option(label: $0) }
//    }
//  }
//
//  var canUpdateOptions: Bool {
//    self == .home
//  }
//}

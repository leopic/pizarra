import Foundation

final class ScreenFactory {
  class func build(id: Screen.Id) -> Screen {
    switch id {
    case .home:
      let binary = Option(label: LocalizedStrings.Option.Label.binary, destination: (screen: .binarySelection, segueId: SegueId.showDetail))
      let mood = Option(label: LocalizedStrings.Option.Label.mood, destination: (screen: .moodSelection, segueId: SegueId.showDetail))
      let pain = Option(label: LocalizedStrings.Option.Label.pain, destination: (screen: .painLevel, segueId: SegueId.showDetail))
      let ambience = Option(label: LocalizedStrings.Option.Label.ambience, destination: (screen: .ambience, segueId: SegueId.showDetail))

      return Screen(title: LocalizedStrings.Screen.Title.home, id: .home, options: [binary, mood, pain, ambience])
    case .binarySelection:
      let positive = Option(label: "👍", backgroundColor: .systemGreen)
      let negative = Option(label: "👎", backgroundColor: .systemRed)

      return Screen(title: LocalizedStrings.Screen.Title.binary, id: .binarySelection, options: [positive, negative], canUpdateOptions: true)
    case .moodSelection:
      let positiveMood = Option(label: "😀", destination: (screen: .positiveMood, segueId: SegueId.showDetail), backgroundColor: .systemYellow)
      let negativeMood = Option(label: "🙁", destination: (screen: .negativeMood, segueId: SegueId.showDetail), backgroundColor: .systemBlue)

      return Screen(title: LocalizedStrings.Screen.Title.mood, id: .moodSelection, options: [positiveMood, negativeMood])
    case .positiveMood:
      let options = ["😀", "✌️", "💪", "💓"].map { Option(label: $0) }
      return Screen(title: LocalizedStrings.Screen.Title.mood, id: .positiveMood, options: options, canUpdateOptions: true)
    case .negativeMood:
      let options = ["😭", "😩", "😡", "❤️"].map { Option(label: $0) }
      return Screen(title: LocalizedStrings.Screen.Title.mood, id: .negativeMood, options: options, canUpdateOptions: true)
    case .painLevel:
      let options = ["1️⃣👌", "2️⃣🙂", "3️⃣😶", "4️⃣🙁", "5️⃣🤕"].map { Option(label: $0) }
      return Screen(title: LocalizedStrings.Screen.Title.pain, id: .painLevel, options: options, canUpdateOptions: true)
    case .ambience:
      let sound = Option(label: "🔊", destination: (screen: .sound, segueId: SegueId.showDetail))
      let temperature = Option(label: "🥵", destination: (screen: .temperature, segueId: SegueId.showDetail))
      return Screen(title: LocalizedStrings.Screen.Title.ambience, id: .ambience, options: [sound, temperature])
    case .sound:
      let options = ["🔊", "🔇"].map { Option(label: $0) }
      return Screen(title: LocalizedStrings.Screen.Title.sound, id: .sound, options: options)
    case .temperature:
      let options = ["🥵", "👌", "🥶"].map { Option(label: $0) }
      return Screen(title: LocalizedStrings.Screen.Title.temperature, id: .temperature, options: options)
    }
  }
}

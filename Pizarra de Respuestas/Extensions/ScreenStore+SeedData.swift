import Foundation

extension ScreenStore {
  class func seedScreen(id: Screen.Id) -> Screen {
    switch id {
    case .home:
      let binary = Option(label: .binaryOption, destination: Option.Destination(screenId: .binarySelection, segueId: SegueId.showDetail))
      let mood = Option(label: .moodOption, destination: Option.Destination(screenId: .moodSelection, segueId: SegueId.showDetail))
      let pain = Option(label: .painOption, destination: Option.Destination(screenId: .painLevel, segueId: SegueId.showDetail))
      let ambience = Option(label: .ambienceOption, destination: Option.Destination(screenId: .ambience, segueId: SegueId.showDetail))

      return Screen(title: .home, id: .home, options: [binary, mood, pain, ambience])
    case .binarySelection:
      let positive = Option(label: "👍", backgroundColor: .systemGreen)
      let negative = Option(label: "👎", backgroundColor: .systemRed)

      return Screen(title: .binary, id: .binarySelection, options: [positive, negative])
    case .moodSelection:
      let positiveMood = Option(label: "😀", destination: Option.Destination(screenId: .positiveMood, segueId: SegueId.showDetail), backgroundColor: .systemYellow)
      let negativeMood = Option(label: "🙁", destination: Option.Destination(screenId: .negativeMood, segueId: SegueId.showDetail), backgroundColor: .systemBlue)

      return Screen(title: .mood, id: .moodSelection, options: [positiveMood, negativeMood])
    case .positiveMood:
      let options = ["😀", "✌️", "💪", "❤️"].map { Option(label: $0) }
      return Screen(title: .moodPositive, id: .positiveMood, options: options, canUpdateOptions: true)
    case .negativeMood:
      let options = ["😭", "😩", "😡", "💔"].map { Option(label: $0) }
      return Screen(title: .moodNegative, id: .negativeMood, options: options, canUpdateOptions: true)
    case .painLevel:
      let options = [
        Option(label: "1️⃣😀", backgroundColor: .systemBlue),
        Option(label: "2️⃣🙂", backgroundColor: .systemGreen),
        Option(label: "3️⃣😶", backgroundColor: .systemYellow),
        Option(label: "4️⃣🙁", backgroundColor: .systemOrange),
        Option(label: "5️⃣😭", backgroundColor: .systemRed)
      ]

      return Screen(title: .pain, id: .painLevel, options: options, canUpdateOptions: true)
    case .ambience:
      let sound = Option(label: "🔊", destination: Option.Destination(screenId: .sound, segueId: SegueId.showDetail))
      let temperature = Option(label: "🥵", destination: Option.Destination(screenId: .temperature, segueId: SegueId.showDetail))
      return Screen(title: .ambience, id: .ambience, options: [sound, temperature])
    case .sound:
      let options = ["🔊", "🔇"].map { Option(label: $0) }
      return Screen(title: .sound, id: .sound, options: options)
    case .temperature:
      let options = ["🥵", "👍", "🥶"].map { Option(label: $0) }
      return Screen(title: .temperature, id: .temperature, options: options)
    }
  }

  func seedData() -> [Screen] {
    [
      ScreenStore.seedScreen(id: .home),
      ScreenStore.seedScreen(id: .binarySelection),
      ScreenStore.seedScreen(id: .moodSelection),
      ScreenStore.seedScreen(id: .positiveMood),
      ScreenStore.seedScreen(id: .negativeMood),
      ScreenStore.seedScreen(id: .painLevel),
      ScreenStore.seedScreen(id: .ambience),
      ScreenStore.seedScreen(id: .sound),
      ScreenStore.seedScreen(id: .temperature),
    ]
  }
}

private extension String {
  // Options
  static let binaryOption = NSLocalizedString("option.label.binary", comment: "Label for the yes / no option")
  static let moodOption = NSLocalizedString("option.label.mood", comment: "Label for the mood option")
  static let painOption = NSLocalizedString("option.label.pain", comment: "Label for the pain option")
  static let ambienceOption = NSLocalizedString("option.label.ambience", comment: "Label for the ambience option")

  // Screens
  static let create = NSLocalizedString("screen.title.create", comment: "Title for the screen to create a new answer")
  static let edit = NSLocalizedString("screen.title.edit", comment: "Title for the screen to edit an answer")
  static let home = NSLocalizedString("screen.title.home", comment: "Title for the home screen")
  static let ambience = NSLocalizedString("screen.title.ambience", comment: "Title for the ambience screen")
  static let pain = NSLocalizedString("screen.title.pain", comment: "Title for the pain screen")
  static let mood = NSLocalizedString("screen.title.mood", comment: "Title for the mood screen")
  static let moodPositive = NSLocalizedString("screen.title.mood.positive", comment: "Title for the positive mood screen")
  static let moodNegative = NSLocalizedString("screen.title.mood.negative", comment: "Title for the negative mood screen")
  static let binary = NSLocalizedString("screen.title.binary", comment: "Title for the binary question screen")
  static let sound = NSLocalizedString("screen.title.sound", comment: "Title for the sound screen")
  static let temperature = NSLocalizedString("screen.title.temperature", comment: "Title for the temperature screen")
}

import Foundation

struct LocalizedStrings {
  struct Alert {
    struct Title {
      static let error = NSLocalizedString("alert.title.error", comment: "Title for error messages")
      static let confirmDeletion = NSLocalizedString("alert.title.confirm-deletion", comment: "Title confirming the deletion of an option")
    }

    struct Message {
      static let errorEmptyOption = NSLocalizedString("alert.title.error.empty.option", comment: "Option can not be empty")
    }
  }

  struct General {
    struct Button {
      static let ok = NSLocalizedString("general.button.okay", comment: "Accept presented information")
      static let delete = NSLocalizedString("general.button.delete", comment: "Delete the selected item")
      static let cancel = NSLocalizedString("general.button.cancel", comment: "Avoid the current action from being executed")
    }
  }

  struct Screen {
    struct Title {
      static let create = NSLocalizedString("screen.title.create", comment: "Title for the screen to create a new option")
      static let edit = NSLocalizedString("screen.title.edit", comment: "Title for the screen to edit an option")
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
  }

  struct Option {
    struct Label {
      static let binary = NSLocalizedString("option.label.binary", comment: "Label for the yes / no option")
      static let mood = NSLocalizedString("option.label.mood", comment: "Label for the mood option")
      static let pain = NSLocalizedString("option.label.pain", comment: "Label for the pain option")
      static let ambience = NSLocalizedString("option.label.ambience", comment: "Label for the ambience option")
    }
  }
}

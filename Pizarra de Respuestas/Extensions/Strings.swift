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
    }
  }
}

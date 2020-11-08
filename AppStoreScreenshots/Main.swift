import XCTest

final class Main: XCTestCase {
  private var app: XCUIApplication!
  private var isPad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
    XCUIDevice.shared.orientation = isPad ? .landscapeLeft : .portrait
    app = XCUIApplication()
    setupSnapshot(app)
    app.launchEnvironment = ["AppStoreScreenshots" : "true"]
    app.launch()
  }

  func testOne() throws {
    snapshot("category-list")

    app.navigationBars.buttons.element(boundBy: 0).tap()
    snapshot("customize-feedback")

    app.cells.element(boundBy: 2).tap()
    snapshot("stats")
  }

  func testTwo() throws {
    app.buttons.element(boundBy: 3).tap()
    snapshot("pain-level")

    app.navigationBars.buttons.element(boundBy: 1).tap()
    app.cells.element(boundBy: 2).tap()
    snapshot("edit-options")
  }
}

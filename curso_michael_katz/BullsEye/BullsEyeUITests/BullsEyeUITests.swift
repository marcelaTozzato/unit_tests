import XCTest

class BullsEyeUITests: XCTestCase {
  
  var app: XCUIApplication!

    override func setUp() {
      app = XCUIApplication()
      app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameStyleSwitch() {
      
      // given
      let slideButton = app.segmentedControls.buttons["Slide"]
      let typeButton = app.segmentedControls.buttons["Type"]
      let slideLabel = app.staticTexts["Get as close as you can to: "]
      let typeLabel = app.staticTexts["Guess where the slider is: "]
      
      //then
      if slideButton.isSelected {
        XCTAssertTrue(slideLabel.exists)
        XCTAssertFalse(typeLabel.exists)
        
        typeButton.tap()
        XCTAssertTrue(typeLabel.exists)
        XCTAssertFalse(slideLabel.exists)
      } else if typeButton.isSelected {
        XCTAssertTrue(typeLabel.exists)
        XCTAssertFalse(slideLabel.exists)

        slideButton.tap()
        XCTAssertTrue(slideLabel.exists)
        XCTAssertFalse(typeLabel.exists)
      }
      
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

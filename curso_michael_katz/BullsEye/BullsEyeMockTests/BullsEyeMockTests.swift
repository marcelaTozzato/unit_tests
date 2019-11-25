import XCTest
@testable import BullsEye

class MockUserDefaults: UserDefaults {
  var gameStyleChanged = 0
  //Muitos testes implementam um valor bool, mas o Int dá mais flexibilidade, e permite testar, inclusive, se o teste é chamado uma única vez:
  override func set(_ value: Int, forKey defaultName: String) {
    if defaultName == "gameStyle" {
      gameStyleChanged += 1
    }
  }
}

class BullsEyeMockTests: XCTestCase {
  
  var sut: ViewController!
  var mockUserDefaults: MockUserDefaults!

    override func setUp() {
      super.setUp()
      sut = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController
      mockUserDefaults = MockUserDefaults(suiteName: "testing")
      sut.defaults = mockUserDefaults
    }

    override func tearDown() {
      sut = nil
      mockUserDefaults = nil
      super.tearDown()
    }
  
  func testGameStyleCanBeChanged() {
    //given
    let segmentedControl = UISegmentedControl()
    
    //when
    XCTAssertEqual(mockUserDefaults.gameStyleChanged, 0, "gameStyleChanged should be 0 before sendActions")
    segmentedControl.addTarget(sut, action: #selector(ViewController.chooseGameStyle(_:)), for: .valueChanged)
    segmentedControl.sendActions(for: .valueChanged)
    
    //then
    XCTAssertEqual(mockUserDefaults.gameStyleChanged, 1, "gameStyle user default wasn't changed")
  }
  //when: gameStyleChanged deve ser 0 antes do teste mudar o segmented control
  //Se o then também for verdade, significa que o set(_:forKey:) foi chamado apenas uma vez

}

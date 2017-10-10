import XCTest
import Omise


class LastDigitsTest: XCTestCase {
  
  func testCreateLastDigitsSuccessfully() {
    let firstLastDigits = LastDigits(lastDigitsString: "1234")
    XCTAssertNotNil(firstLastDigits)
    XCTAssertEqual(firstLastDigits?.lastDigits, "1234")
    
    let secondLastDigits = LastDigits(lastDigitsString: "1111")
    XCTAssertNotNil(secondLastDigits)
    XCTAssertEqual(secondLastDigits?.lastDigits, "1111")
    
    let thirdLastDigits = LastDigits(lastDigitsString: "4242")
    XCTAssertNotNil(thirdLastDigits)
    XCTAssertEqual(thirdLastDigits?.lastDigits, "4242")
  }
  
  func testFailyCreateLastDigits() {
    let firstTry = LastDigits(lastDigitsString: "123")
    XCTAssertNil(firstTry)
    
    let secondTry = LastDigits(lastDigitsString: "")
    XCTAssertNil(secondTry)
    
    let thirdTry = LastDigits(lastDigitsString: "12345")
    XCTAssertNil(thirdTry)
    
    let forthTry = LastDigits(lastDigitsString: "abcd")
    XCTAssertNil(forthTry)
    
    let fifthTry = LastDigits(lastDigitsString: "123a")
    XCTAssertNil(fifthTry)
  }
  
  func testLastDigitsEquality() {
    let firstLastDigits = LastDigits(lastDigitsString: "1234")!
    let secondLastDigits = LastDigits(lastDigitsString: "1234")!
    let thirdLastDigits = LastDigits(lastDigitsString: "4242")!
    
    XCTAssertEqual(firstLastDigits, secondLastDigits)
    XCTAssertNotEqual(firstLastDigits, thirdLastDigits)
  }
}

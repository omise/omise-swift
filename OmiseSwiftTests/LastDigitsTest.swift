import XCTest
import Omise


class LastDigitsTest: XCTestCase {
  
  func testCreateLastDigitsSuccessfully() {
    let firstLastDigits = Digits(digitsString: "1234")
    XCTAssertNotNil(firstLastDigits)
    XCTAssertEqual(firstLastDigits?.digits, "1234")
    
    let secondLastDigits = Digits(digitsString: "1111")
    XCTAssertNotNil(secondLastDigits)
    XCTAssertEqual(secondLastDigits?.digits, "1111")
    
    let thirdLastDigits = Digits(digitsString: "4242")
    XCTAssertNotNil(thirdLastDigits)
    XCTAssertEqual(thirdLastDigits?.digits, "4242")
  }
  
  func testFailyCreateLastDigits() {
    let firstTry = Digits(digitsString: "123")
    XCTAssertNil(firstTry)
    
    let secondTry = Digits(digitsString: "")
    XCTAssertNil(secondTry)
    
    let thirdTry = Digits(digitsString: "12345")
    XCTAssertNil(thirdTry)
    
    let forthTry = Digits(digitsString: "abcd")
    XCTAssertNil(forthTry)
    
    let fifthTry = Digits(digitsString: "123a")
    XCTAssertNil(fifthTry)
  }
  
  func testLastDigitsEquality() {
    let firstLastDigits = Digits(digitsString: "1234")!
    let secondLastDigits = Digits(digitsString: "1234")!
    let thirdLastDigits = Digits(digitsString: "4242")!
    
    XCTAssertEqual(firstLastDigits, secondLastDigits)
    XCTAssertNotEqual(firstLastDigits, thirdLastDigits)
  }
}

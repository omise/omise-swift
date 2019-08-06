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
    
    let forthLastDigits = Digits(digitsString: "123")
    XCTAssertNotNil(forthLastDigits)
    XCTAssertEqual(forthLastDigits?.digits, "123")
    
    let fifthLastDigits = Digits(digitsString: "12345")
    XCTAssertNotNil(fifthLastDigits)
    XCTAssertEqual(fifthLastDigits?.digits, "12345")
  }
  
  func testFailyCreateLastDigits() {
    let firstTry = Digits(digitsString: "")
    XCTAssertNil(firstTry)
    
    let secondTry = Digits(digitsString: "abcd")
    XCTAssertNil(secondTry)
    
    let thirdTry = Digits(digitsString: "123a")
    XCTAssertNil(thirdTry)
  }
  
  func testLastDigitsEquality() {
    let firstLastDigits = Digits(digitsString: "1234")!
    let secondLastDigits = Digits(digitsString: "1234")!
    let thirdLastDigits = Digits(digitsString: "4242")!
    
    XCTAssertEqual(firstLastDigits, secondLastDigits)
    XCTAssertNotEqual(firstLastDigits, thirdLastDigits)
  }
}

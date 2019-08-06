import XCTest
import Omise

class FirstDigitsTest: XCTestCase {
    
    func testCreateFirstDigitsSuccessfully() {
        let firstOfFirstDigits = Digits(digitsString: "123456")
        XCTAssertNotNil(firstOfFirstDigits)
        XCTAssertEqual(firstOfFirstDigits?.digits, "123456")
        
        let secondOfFirstDigits = Digits(digitsString: "1111")
        XCTAssertNotNil(secondOfFirstDigits)
        XCTAssertEqual(secondOfFirstDigits?.digits, "1111")
        
        let thirdOfFirstDigits = Digits(digitsString: "42")
        XCTAssertNotNil(thirdOfFirstDigits)
        XCTAssertEqual(thirdOfFirstDigits?.digits, "42")
    }
    
    func testFailyCreateFirstDigits() {
        let firstTry = Digits(digitsString: "")
        XCTAssertNil(firstTry)
        
        let secondTry = Digits(digitsString: "abcd")
        XCTAssertNil(secondTry)
        
        let thirdTry = Digits(digitsString: "123a")
        XCTAssertNil(thirdTry)
    }
    
    func testFirstDigitsEquality() {
        let firstOfFirstDigits = Digits(digitsString: "123456")!
        let secondOfFirstDigits = Digits(digitsString: "123456")!
        let thirdOfFirstDigits = Digits(digitsString: "654321")!
        
        XCTAssertEqual(firstOfFirstDigits, secondOfFirstDigits)
        XCTAssertNotEqual(firstOfFirstDigits, thirdOfFirstDigits)
    }
}

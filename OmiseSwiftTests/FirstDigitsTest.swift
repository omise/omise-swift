import XCTest
import Omise

class FirstDigitsTest: XCTestCase {
    
    func testCreateFirstDigitsSuccessfully() {
        let firstOfFirstDigits = FirstDigits(firstDigitsString: "123456")
        XCTAssertNotNil(firstOfFirstDigits)
        XCTAssertEqual(firstOfFirstDigits?.firstDigits, "123456")
        
        let secondOfFirstDigits = FirstDigits(firstDigitsString: "1111")
        XCTAssertNotNil(secondOfFirstDigits)
        XCTAssertEqual(secondOfFirstDigits?.firstDigits, "1111")
        
        let thirdOfFirstDigits = FirstDigits(firstDigitsString: "42")
        XCTAssertNotNil(thirdOfFirstDigits)
        XCTAssertEqual(thirdOfFirstDigits?.firstDigits, "42")
    }
    
    func testFailyCreateFirstDigits() {
        let firstTry = FirstDigits(firstDigitsString: "")
        XCTAssertNil(firstTry)
        
        let secondTry = FirstDigits(firstDigitsString: "abcd")
        XCTAssertNil(secondTry)
        
        let thirdTry = FirstDigits(firstDigitsString: "123a")
        XCTAssertNil(thirdTry)
    }
    
    func testFirstDigitsEquality() {
        let firstOfFirstDigits = FirstDigits(firstDigitsString: "123456")!
        let secondOfFirstDigits = FirstDigits(firstDigitsString: "123456")!
        let thirdOfFirstDigits = FirstDigits(firstDigitsString: "654321")!
        
        XCTAssertEqual(firstOfFirstDigits, secondOfFirstDigits)
        XCTAssertNotEqual(firstOfFirstDigits, thirdOfFirstDigits)
    }
}

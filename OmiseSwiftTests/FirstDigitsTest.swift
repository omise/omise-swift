import XCTest
import Omise

class FirstDigitsTest: XCTestCase {
    
    func testCreateFirstDigitsSuccessfully() {
        let firstOfFirstDigits = FirstDigits(firstDigitsString: "123456")
        XCTAssertNotNil(firstOfFirstDigits)
        XCTAssertEqual(firstOfFirstDigits?.firstDigits, "123456")
        
        let secondOfFirstDigits = FirstDigits(firstDigitsString: "111111")
        XCTAssertNotNil(secondOfFirstDigits)
        XCTAssertEqual(secondOfFirstDigits?.firstDigits, "111111")
        
        let thirdOfFirstDigits = FirstDigits(firstDigitsString: "424242")
        XCTAssertNotNil(thirdOfFirstDigits)
        XCTAssertEqual(thirdOfFirstDigits?.firstDigits, "424242")
    }
    
    func testFailyCreateFirstDigits() {
        let firstTry = FirstDigits(firstDigitsString: "123")
        XCTAssertNil(firstTry)
        
        let secondTry = FirstDigits(firstDigitsString: "")
        XCTAssertNil(secondTry)
        
        let thirdTry = FirstDigits(firstDigitsString: "12345")
        XCTAssertNil(thirdTry)
        
        let forthTry = FirstDigits(firstDigitsString: "abcd")
        XCTAssertNil(forthTry)
        
        let fifthTry = FirstDigits(firstDigitsString: "123a")
        XCTAssertNil(fifthTry)
    }
    
    func testLastDigitsEquality() {
        let firstOfFirstDigits = FirstDigits(firstDigitsString: "123456")!
        let secondOfFirstDigits = FirstDigits(firstDigitsString: "123456")!
        let thirdOfFirstDigits = FirstDigits(firstDigitsString: "654321")!
        
        XCTAssertEqual(firstOfFirstDigits, secondOfFirstDigits)
        XCTAssertNotEqual(firstOfFirstDigits, thirdOfFirstDigits)
    }
}

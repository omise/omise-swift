import XCTest
import Omise

class DigitsTest: XCTestCase {
    func testCreateDigitsSuccessfully() {
        let firstDigits = Digits(digitsString: "1234")
        XCTAssertNotNil(firstDigits)
        XCTAssertEqual(firstDigits?.digits, "1234")
        
        let secondDigits = Digits(digitsString: "1111")
        XCTAssertNotNil(secondDigits)
        XCTAssertEqual(secondDigits?.digits, "1111")
        
        let thirdDigits = Digits(digitsString: "4242")
        XCTAssertNotNil(thirdDigits)
        XCTAssertEqual(thirdDigits?.digits, "4242")
        
        let forthDigits = Digits(digitsString: "123")
        XCTAssertNotNil(forthDigits)
        XCTAssertEqual(forthDigits?.digits, "123")
        
        let fifthDigits = Digits(digitsString: "12345")
        XCTAssertNotNil(fifthDigits)
        XCTAssertEqual(fifthDigits?.digits, "12345")
        
        let sixthDigits = Digits(digitsString: "123456")
        XCTAssertNotNil(sixthDigits)
        XCTAssertEqual(sixthDigits?.digits, "123456")
        
        let seventhDigits = Digits(digitsString: "42")
        XCTAssertNotNil(seventhDigits)
        XCTAssertEqual(seventhDigits?.digits, "42")

    }
    
    func testFailyCreateDigits() {
        let firstTry = Digits(digitsString: "")
        XCTAssertNil(firstTry)
        
        let secondTry = Digits(digitsString: "abcd")
        XCTAssertNil(secondTry)
        
        let thirdTry = Digits(digitsString: "123a")
        XCTAssertNil(thirdTry)
    }
    
    func testDigitsEquality() throws {
        let firstDigits = try XCTUnwrap(Digits(digitsString: "1234"))
        let secondDigits = try XCTUnwrap(Digits(digitsString: "1234"))
        let thirdDigits = try XCTUnwrap(Digits(digitsString: "4242"))
        
        XCTAssertEqual(firstDigits, secondDigits)
        XCTAssertNotEqual(firstDigits, thirdDigits)
    }
}

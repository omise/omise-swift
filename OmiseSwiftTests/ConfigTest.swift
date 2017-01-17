import Foundation
import XCTest
@testable import Omise

class ConfigTest: OmiseTestCase {
    func testCtor() {
        let config = APIConfiguration(
            apiVersion: "789",
            publicKey: "789",
            secretKey: "789")
        XCTAssertEqual("789", config.secretKey)
        XCTAssertNil(config.publicKey)
        XCTAssertNil(config.apiVersion)
    }
}

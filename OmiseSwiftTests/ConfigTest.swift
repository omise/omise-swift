import Foundation
import XCTest
import Omise

class ConfigTest: OmiseTestCase {
    func testCtor() {
        let config = Config(publicKey: "123", secretKey: "456", apiVersion: "dandy")
        XCTAssertEqual(config.publicKey, "123")
        XCTAssertEqual(config.secretKey, "456")
        XCTAssertEqual(config.apiVersion, "dandy")
    }
}

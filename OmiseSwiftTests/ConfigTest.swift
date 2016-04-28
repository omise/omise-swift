import Foundation
import XCTest
import Omise

class ConfigTest: OmiseTestCase {
    func testCtor() {
        var config = Config(secretKey: "789")
        XCTAssertEqual("789", config.secretKey)
        XCTAssertNil(config.publicKey)
        XCTAssertNil(config.apiVersion)
        XCTAssertEqual(config.callbackQueue, NSOperationQueue.mainQueue())
        
        config = Config(publicKey: "123", secretKey: "456")
        XCTAssertEqual(config.publicKey, "123")
        XCTAssertEqual(config.secretKey, "456")
        XCTAssertNil(config.apiVersion)
        XCTAssertEqual(config.callbackQueue, NSOperationQueue.mainQueue())
        
        let queue = NSOperationQueue()
        
        config = Config(publicKey: "123", secretKey: "456", apiVersion: "dandy", queue: queue)
        XCTAssertEqual(config.publicKey, "123")
        XCTAssertEqual(config.secretKey, "456")
        XCTAssertEqual(config.apiVersion, "dandy")
        XCTAssertEqual(config.callbackQueue, queue)
    }
}

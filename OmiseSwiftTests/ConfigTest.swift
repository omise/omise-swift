import Foundation
import XCTest
import Omise

class ConfigTest: OmiseTestCase {
    func testCtor() {
        var config = Config(secretKey: "789")
        XCTAssertEqual("789", config.secretKey)
        XCTAssertNil(config.publicKey)
        XCTAssertNil(config.apiVersion)
        XCTAssertEqual(config.callbackQueue, OperationQueue.main)
        
        config = Config(publicKey: "123", secretKey: "456")
        XCTAssertEqual(config.publicKey, "123")
        XCTAssertEqual(config.secretKey, "456")
        XCTAssertNil(config.apiVersion)
        XCTAssertEqual(config.callbackQueue, OperationQueue.main)
        
        let queue = OperationQueue()
        
        config = Config(publicKey: "123", secretKey: "456", apiVersion: "dandy", queue: queue)
        XCTAssertEqual(config.publicKey, "123")
        XCTAssertEqual(config.secretKey, "456")
        XCTAssertEqual(config.apiVersion, "dandy")
        XCTAssertEqual(config.callbackQueue, queue)
    }
}

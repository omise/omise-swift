import Foundation
import Omise
import XCTest

class OperationTest: OmiseTestCase {
    let operation = Operation(
        endpoint: Endpoint.Vault,
        method: "GET",
        path: "/account",
        values: [
            "hello": "world",
            "key": "with spaces"
        ]
    )
    
    func testCtor() {
        XCTAssertEqual(operation.endpoint, Endpoint.Vault)
        XCTAssertEqual(operation.method, "GET")
        XCTAssertEqual(operation.path, "/account")
        XCTAssertEqual(operation.values, ["hello": "world", "key": "with spaces"])
    }
    
    func testURL() {
        XCTAssertEqual(operation.url.absoluteString, "https://vault.omise.co/account")
    }
    
    func testPayload() {
        guard let payload = operation.payload,
            let payloadStr = String(data: payload, encoding: NSUTF8StringEncoding) else {
            return XCTFail("payload encoding failure.")
        }
        
        XCTAssert(payloadStr.containsString("hello=world"))
        XCTAssert(payloadStr.containsString("key=with%20spaces"))
    }
}
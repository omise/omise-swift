import Foundation
import Omise
import XCTest

class OperationTest: OmiseTestCase {
    func testCtor() {
        let operation = Operation(
            endpoint: Endpoint.Vault,
            method: "get",
            path: "/account",
            values: [
                "hello": "world",
                "key": "with spaces"
            ]
        )
        
        let expectedUrl = "https://vault.omise.co/account?hello=world&key=with%20spaces"
        
        XCTAssertEqual(operation.endpoint, Endpoint.Vault)
        XCTAssertEqual(operation.method, "GET") // method upcased
        XCTAssertEqual(operation.url.absoluteString, expectedUrl)
        XCTAssertEqual(operation.payload, nil)
    }
    
    func testCtorWithPayload() {
        let operation = Operation(
            endpoint: Endpoint.Vault,
            method: "post",
            path: "/account",
            values: [
                "hello": "world",
                "key": "with spaces",
                "morekeys": "with=symbols=&?"
            ]
        )
    
        guard let payload = operation.payload,
            let payloadStr = String(data: payload, encoding: NSUTF8StringEncoding) else {
            return XCTFail("payload encoding failure.")
        }
        
        XCTAssert(payloadStr.containsString("hello=world"))
        XCTAssert(payloadStr.containsString("key=with%20spaces"))
        XCTAssert(payloadStr.containsString("morekeys=with%3Dsymbols%3D%26?"))
    }
}
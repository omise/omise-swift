import Foundation
import Omise
import XCTest

class OperationTest: OmiseTestCase {
    func testDefaultCtor() {
        let operation: DefaultOperation<Account> = DefaultOperation()
        
        let expectedUrl = "https://vault.omise.co/account?hello=world&key=with%20spaces"
        XCTAssertEqual(operation.endpoint, Endpoint.Vault)
        XCTAssertEqual(operation.method, "GET") // method upcased
        XCTAssertEqual(operation.url.absoluteString, expectedUrl)
        XCTAssertEqual(operation.payload, nil)
    }
    
    class DefaultWithPayload: DefaultOperation<Account> {
        override var method: String { return "POST" }
        
        var hello: String? {
            get { return get("hello", StringConverter.self) }
            set { set("hello", StringConverter.self, toValue: newValue) }
        }
    }
    
    func testDefaultCtorWithPayload() {
        let operation = DefaultWithPayload()
        operation.hello = "world"
    
        guard let payload = operation.payload,
            let payloadStr = String(data: payload, encoding: NSUTF8StringEncoding) else {
            return XCTFail("payload encoding failure.")
        }
        
        XCTAssert(payloadStr.containsString("hello=world"))
        XCTAssert(payloadStr.containsString("key=with%20spaces"))
        XCTAssert(payloadStr.containsString("morekeys=with%3Dsymbols%3D%26?"))
    }
}
import Foundation
import Omise
import XCTest

class OperationTest: OmiseTestCase {
    class DefaultWithPayload: DefaultOperation<Account> {
        var hello: String? {
            get { return get("hello", StringConverter.self) }
            set { set("hello", StringConverter.self, toValue: newValue) }
        }
        
        var key: String? {
            get { return get("key", StringConverter.self) }
            set { set("key", StringConverter.self, toValue: newValue) }
        }
        
        required init(attributes: JSONAttributes = [:]) {
            super.init(attributes: attributes)
            self.method = "POST"
        }
    }
    
    func testDefault() {
        let operation: DefaultOperation<Account> = DefaultOperation()
        
        let expectedUrl = "https://api.omise.co/"
        XCTAssertEqual(operation.endpoint, Endpoint.API)
        XCTAssertEqual(operation.method, "GET") // method upcased
        XCTAssertEqual(operation.url.absoluteString, expectedUrl)
        XCTAssertEqual(operation.payload, nil)
    }
    
    func testOperationWithPayload() {
        let operation = DefaultWithPayload()
        operation.hello = "world"
        operation.key = "value with spaces and=symbols?!&"
    
        guard let payload = operation.payload,
            let payloadStr = String(data: payload, encoding: NSUTF8StringEncoding) else {
            return XCTFail("payload encoding failure.")
        }
        
        XCTAssertEqual("hello=world&key=value%20with%20spaces%20and%3Dsymbols?!%26", payloadStr)
    }
}
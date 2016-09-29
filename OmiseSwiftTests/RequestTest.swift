import Foundation
import XCTest
import Omise

class RequestTest: OmiseTestCase {
    let config = Config(publicKey: "pkey_test_123", secretKey: "skey_test_123")
    let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
//    func testCtor() {
//        guard let request: Request<Account> = Request(
//            config: config,
//            session: session,
//            operation: Operation(
//                endpoint: Endpoint.API,
//                method: "GET",
//                path: "/account",
//                values: [:]
//            )) else {
//                return XCTFail("failed to build a request")
//        }
//        
//        XCTAssertEqual(request.config, config)
//        XCTAssertEqual(request.session, session)
//        XCTAssertEqual(request.operation.endpoint, Endpoint.API)
//        XCTAssertEqual(request.operation.method, "GET")
//    }
}

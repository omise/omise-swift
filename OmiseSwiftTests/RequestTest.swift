import Foundation
import XCTest
import Omise

class RequestTest: OmiseTestCase {
    let config = APIConfiguration(
        apiVersion: "2015-11-17",
        publicKey: "pkey_test_123",
        secretKey: "skey_test_123")
    let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
//    func testCtor() {
//        guard let request: APIRequest<Account> = APIRequest(
//            config: config,
//            session: session,
//            operation: APIEndpoint(
//                endpoint: APIEndpoint.API,
//                method: "GET",
//                path: "/account",
//                values: [:]
//            )) else {
//                return XCTFail("failed to build a request")
//        }
//        
//        XCTAssertEqual(request.config, config)
//        XCTAssertEqual(request.session, session)
//        XCTAssertEqual(request.operation.endpoint, APIEndpoint.API)
//        XCTAssertEqual(request.operation.method, "GET")
//    }
}

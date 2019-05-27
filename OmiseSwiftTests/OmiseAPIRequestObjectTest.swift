import Foundation
import XCTest
@testable import Omise


class OmiseAPIRequestObjectTest: OmiseTestCase {
    
    func testChargeRequest() {
        do {
            let request = Charge.listEndpointWith(params: nil)
            XCTAssertEqual(request.pathComponents, [Charge.resourceInfo.path])
        }
    }
    
}


import Foundation
import XCTest
@testable import Omise


class OmiseAPIRequestObjectTest: FixtureTestCase {
    
    func testChargeRequest() {
        do {
            let request = Charge.listEndpointWith(params: nil)
            XCTAssertEqual(request.pathComponents, [Charge.resourceInfo.path])
        }
    }
    
    func testCustomerRequest() {
        do {
            let request = Customer.listEndpointWith(params: nil)
            XCTAssertEqual(request.pathComponents, [Customer.resourceInfo.path])
        }
        
        do {
            let customer = try! fixturesObjectFor(type: Customer.self, dataID: "cust_test_5fz0olfpy32zadv96ek")
            let request = customer.listEndpoint(keyPath: \.cards, params: nil)
            XCTAssertEqual(request.pathComponents, [Customer.resourceInfo.path, customer.id, CustomerCard.resourceInfo.path])
        }
    }
    
    func testLinkRequest() {
        do {
            let request = Link.listEndpointWith(params: nil)
            XCTAssertEqual(request.pathComponents, [Link.resourceInfo.path])
        }
        
        do {
            let link = try! fixturesObjectFor(type: Link.self, dataID: "link_test_5bh0ji63ctfk4gug2d5")
            let request = link.listEndpoint(keyPath: \.charges, params: nil)
            XCTAssertEqual(request.pathComponents, [Link.resourceInfo.path, link.id, Charge.resourceInfo.path])
        }
    }
    
    func testRefundRequest() {
        do {
            let request = Refund.listEndpointWith(params: nil)
            XCTAssertEqual(request.pathComponents, [Refund.resourceInfo.path])
        }
        
        do {
            let charge = try! fixturesObjectFor(type: Charge.self, dataID: "chrg_test_refunded")
            let request = charge.listEndpoint(keyPath: \Charge.refunds, params: nil)
            XCTAssertEqual(request.pathComponents, [Charge.resourceInfo.path, charge.id, Refund.resourceInfo.path])
        }
        
        do {
            let params = RefundParams(amount: 10_000)
            
        }
    }
}


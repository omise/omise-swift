import Foundation
import XCTest
@testable import Omise


class OmiseAPIRequestObjectTest: FixtureTestCase {
    
    func testChargeRequest() {
        do {
            let request = Charge.listEndpoint(with: nil)
            XCTAssertEqual(request.pathComponents, [Charge.resourcePath])
        }
        
        do {
            let chargeID: DataID<Charge> = "chrg_test_5frvn3hgya3qemayzrt"
            let request = Charge.captureEndpoint(for: chargeID)
            XCTAssertEqual(request.pathComponents, [Charge.resourcePath, chargeID.idString, "capture"])
        }
        
        do {
            let chargeID: DataID<Charge> = "chrg_test_5frvn3hgya3qemayzrt"
            let request = Charge.reverseEndpoint(for: chargeID)
            XCTAssertEqual(request.pathComponents, [Charge.resourcePath, chargeID.idString, "reverse"])
        }
    }
    
    func testCustomerRequest() {
        do {
            let request = Customer.listEndpoint(with: nil)
            XCTAssertEqual(request.pathComponents, [Customer.resourcePath])
        }
        
        do {
            let customer = try! fixturesObjectFor(type: Customer.self, dataID: "cust_test_5fz0olfpy32zadv96ek")
            let request = customer.listEndpoint(keyPath: \.cards, params: nil)
            XCTAssertEqual(request.pathComponents, [Customer.resourcePath, customer.id.idString, CustomerCard.resourcePath])
        }
    }
    
    func testLinkRequest() {
        do {
            let request = Link.listEndpoint(with: nil)
            XCTAssertEqual(request.pathComponents, [Link.resourcePath])
        }
        
        do {
            let link = try! fixturesObjectFor(type: Link.self, dataID: "link_test_5bh0ji63ctfk4gug2d5")
            let request = link.listEndpoint(keyPath: \.charges, params: nil)
            XCTAssertEqual(request.pathComponents, [Link.resourcePath, link.id.idString, Charge.resourcePath])
        }
    }
    
    func testRefundRequest() {
        do {
            let request = Refund.listEndpoint(with: nil)
            XCTAssertEqual(request.pathComponents, [Refund.resourcePath])
        }
        
        do {
            let charge = try! fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5frvn3hgya3qemayzrt")
            let request = charge.listEndpoint(keyPath: \Charge.refunds, params: nil)
            XCTAssertEqual(request.pathComponents, [Charge.resourcePath, charge.id.idString, Refund.resourcePath])
        }
        
        do {
            let charge = try! fixturesObjectFor(type: Charge.self, dataID: "chrg_test_5frvn3hgya3qemayzrt")
            let refundParams = RefundParams(amount: 10_00)
            let request = Refund.createEndpointWith(parent: charge, params: refundParams)
            XCTAssertEqual(request.pathComponents, [Charge.resourcePath, charge.id.idString, Refund.resourcePath])
            XCTAssertEqual(request.method, .post)
            XCTAssertEqual(request.query?.amount, 10_00)
        }
    }
}


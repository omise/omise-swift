import Foundation
import XCTest
import Omise

class JSONTest: OmiseTestCase {
    func testAccount() {
        let account = buildFromFixtures("account", type: Account.self)
        XCTAssertEqual(account.object, "account")
        XCTAssertEqual(account.id, "acct_4x7d2wtqnj2f4klrfsc")
        XCTAssertEqual(account.email, "gedeon@gedeon.be")
        XCTAssertEqual(account.created?.timeIntervalSince1970, 1432097856.0)
    }
    
    func testBalance() {
        let balance = buildFromFixtures("balance", type: Balance.self)
        XCTAssertEqual(balance.object, "balance")
        XCTAssertEqual(balance.live, false)
        XCTAssertEqual(balance.available, 380470)
        XCTAssertEqual(balance.total, 380470)
        XCTAssertEqual(balance.currency, "thb")
    }
    
    func testCard() {
        let card = buildFromFixtures("card", type: Card.self)
        XCTAssertEqual(card.object, "card")
        XCTAssertEqual(card.id, "card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(card.live, false)
        XCTAssertEqual(card.location, "/customers/cust_test_5086xleuh9ft4bn0ac2/cards/card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(card.country, "us")
        XCTAssertEqual(card.city, "Bangkok")
        XCTAssertEqual(card.postalCode, "10320")
        XCTAssertEqual(card.financing, "")
        XCTAssertEqual(card.lastDigits, "4242")
        XCTAssertEqual(card.brand, "Visa")
        XCTAssertEqual(card.expirationMonth, 10)
        XCTAssertEqual(card.expirationYear, 2018)
        XCTAssertEqual(card.fingerprint, "mKleiBfwp+PoJWB/ipngANuECUmRKjyxROwFW5IO7TM=")
        XCTAssertEqual(card.name, "Somchai Prasert")
        XCTAssertEqual(card.securityCodeCheck, true)
        XCTAssertEqual(card.created?.timeIntervalSince1970, 1433223706.0)
    }
    
    func testCharge() {
        let charge = buildFromFixtures("charge", type: Charge.self)
        XCTAssertEqual(charge.object, "charge")
        XCTAssertEqual(charge.id, "chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(charge.status, ChargeStatus.Successful)
        XCTAssertEqual(charge.live, false)
        XCTAssertEqual(charge.location, "/charges/chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(charge.amount, 100000)
        XCTAssertEqual(charge.currency, "thb")
        XCTAssertEqual(charge.chargeDescription, nil)
        XCTAssertEqual(charge.authorized, true)
        XCTAssertEqual(charge.paid, true)
        XCTAssertEqual(charge.transaction, "trxn_test_5086xltqqbv4qpmu0ri")
        XCTAssertEqual(charge.refunded, 0)
        XCTAssertEqual(charge.failureCode, nil)
        XCTAssertEqual(charge.failureMessage, nil)
        XCTAssertEqual(charge.customer, "cust_test_5086xleuh9ft4bn0ac2")
        XCTAssertEqual(charge.ip, nil)
        XCTAssertEqual(charge.created?.timeIntervalSince1970, 1433223709.0)
        
        guard let refunds = charge.refunds else { return XCTFail("refunds not deserialized") }
        dump(String(refunds.dynamicType))
        XCTAssertEqual(refunds.object, "list")
        XCTAssertEqual(refunds.limit, 20)
        
        guard let card = charge.card else { return XCTFail("card not deserialized") }
        XCTAssertEqual(card.object, "card")
        XCTAssertEqual(card.id, "card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(card.location, "/customers/cust_test_5086xleuh9ft4bn0ac2/cards/card_test_5086xl7amxfysl0ac5l")
    }
    
    func testRefund() {
        let refund = buildFromFixtures("refund", type: Refund.self)
        XCTAssertEqual(refund.object, "refund")
        XCTAssertEqual(refund.id, "rfnd_test_5086xm1i7ddm3apeaev")
        XCTAssertEqual(refund.location, "/charges/chrg_test_5086xlsx4lghk9bpb75/refunds/rfnd_test_5086xm1i7ddm3apeaev")
        XCTAssertEqual(refund.amount, 20000)
        XCTAssertEqual(refund.currency, "thb")
        XCTAssertEqual(refund.charge, "chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(refund.transaction, "trxn_test_5086xm1mbshmohdhk00")
        XCTAssertEqual(refund.created?.timeIntervalSince1970, 1433223710.0)
    }
    
    private func buildFromFixtures<TObject: OmiseObject>(name: String, type: TObject.Type) -> TObject {
        let path = "Fixtures/objects/\(name)_object"
        guard let data = fixturesDataFor(path) else {
            XCTFail("could not load fixtures path: \(path)")
            return TObject()
        }
        
        guard let result: TObject = OmiseSerializer.deserialize(data) else {
            XCTFail("JSON deserialization failure.")
            return TObject()
        }
        
        return result
    }
}

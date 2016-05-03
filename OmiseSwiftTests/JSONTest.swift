import Foundation
import XCTest
import Omise

class JSONTest: OmiseTestCase {
    func testAccount() {
        let account: Account = buildFromFixtures("account")
        XCTAssertEqual(account.object, "account")
        XCTAssertEqual(account.id, "acct_4x7d2wtqnj2f4klrfsc")
        XCTAssertEqual(account.email, "gedeon@gedeon.be")
        XCTAssertEqual(account.created?.timeIntervalSince1970, 1432097856.0)
    }
    
    func testBalance() {
        let balance: Balance = buildFromFixtures("balance")
        XCTAssertEqual(balance.object, "balance")
        XCTAssertEqual(balance.live, false)
        XCTAssertEqual(balance.available, 380470)
        XCTAssertEqual(balance.total, 380470)
        XCTAssertEqual(balance.currency, "thb")
    }
    
    func testCard() {
        let card: Card = buildFromFixtures("card")
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
        let charge: Charge = buildFromFixtures("charge")
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
        XCTAssertEqual(refunds.object, "list")
        XCTAssertEqual(refunds.limit, 20)
        
        guard let card = charge.card else { return XCTFail("card not deserialized") }
        XCTAssertEqual(card.object, "card")
        XCTAssertEqual(card.id, "card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(card.location, "/customers/cust_test_5086xleuh9ft4bn0ac2/cards/card_test_5086xl7amxfysl0ac5l")
    }
    
    func testCustomer() {
        let customer: Customer = buildFromFixtures("customer")
        XCTAssertEqual(customer.object, "customer")
        XCTAssertEqual(customer.id, "cust_test_5086xleuh9ft4bn0ac2")
        XCTAssertEqual(customer.live, false)
        XCTAssertEqual(customer.location, "/customers/cust_test_5086xleuh9ft4bn0ac2")
        XCTAssertEqual(customer.defaultCard, "card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(customer.email, "john.doe@example.com")
        XCTAssertEqual(customer.customerDescription, "John Doe (id: 30)")
        XCTAssertEqual(customer.created?.timeIntervalSince1970, 1433223707.0)
        
        guard let cards = customer.cards else { return XCTFail("cards not deserialized") }
        XCTAssertEqual(cards.object, "list")
        XCTAssertEqual(cards.limit, 20)
        XCTAssertEqual(cards.location, "/customers/cust_test_5086xleuh9ft4bn0ac2/cards")
    }
    
    func testDispute() {
        let dispute: Dispute = buildFromFixtures("dispute")
        XCTAssertEqual(dispute.object, "dispute")
        XCTAssertEqual(dispute.id, "dspt_test_4zgf15h89w8t775kcm8")
        XCTAssertEqual(dispute.live, false)
        XCTAssertEqual(dispute.location, "/disputes/dspt_test_4zgf15h89w8t775kcm8")
        XCTAssertEqual(dispute.amount, 100000)
        XCTAssertEqual(dispute.currency, "thb")
        XCTAssertEqual(dispute.status, DisputeStatus.Pending)
        XCTAssertEqual(dispute.message, "This is an unauthorized transaction")
    }
    
    func testRecipient() {
        let recipient: Recipient = buildFromFixtures("recipient")
        XCTAssertEqual(recipient.object, "recipient")
        XCTAssertEqual(recipient.id, "recp_test_5086xmr74vxs0ajpo78")
        XCTAssertEqual(recipient.live, false)
        XCTAssertEqual(recipient.location, "/recipients/recp_test_5086xmr74vxs0ajpo78")
        XCTAssertEqual(recipient.verified, false)
        XCTAssertEqual(recipient.active, false)
        XCTAssertEqual(recipient.name, "Somchai Prasert")
        XCTAssertEqual(recipient.email, "somchai.prasert@example.com")
        XCTAssertEqual(recipient.recipientDescription, nil)
        XCTAssertEqual(recipient.type, RecipientType.Individual)
        XCTAssertEqual(recipient.taxId, nil)
        XCTAssertEqual(recipient.failureCode, nil)
        XCTAssertEqual(recipient.created?.timeIntervalSince1970, 1433223713.0)
        
        guard let bankAccount = recipient.bankAccount else { return XCTFail("bank_account not deserialized") }
        XCTAssertEqual(bankAccount.object, "bank_account")
        XCTAssertEqual(bankAccount.brand, "bbl")
        XCTAssertEqual(bankAccount.lastDigits, "7890")
    }
    
    func testRefund() {
        let refund: Refund = buildFromFixtures("refund")
        XCTAssertEqual(refund.object, "refund")
        XCTAssertEqual(refund.id, "rfnd_test_5086xm1i7ddm3apeaev")
        XCTAssertEqual(refund.location, "/charges/chrg_test_5086xlsx4lghk9bpb75/refunds/rfnd_test_5086xm1i7ddm3apeaev")
        XCTAssertEqual(refund.amount, 20000)
        XCTAssertEqual(refund.currency, "thb")
        XCTAssertEqual(refund.charge, "chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(refund.transaction, "trxn_test_5086xm1mbshmohdhk00")
        XCTAssertEqual(refund.created?.timeIntervalSince1970, 1433223710.0)
    }
    
    private func buildFromFixtures<TObject: OmiseObject>(name: String) -> TObject {
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

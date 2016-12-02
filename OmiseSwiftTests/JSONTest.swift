import Foundation
import XCTest
import Omise

class JSONTest: OmiseTestCase {
    func testAccount() {
        let account: Account = makeObject(fromFixturesWithName: "account")
        XCTAssertEqual(account.object, "account")
        XCTAssertEqual(account.id, "acct_4x7d2wtqnj2f4klrfsc")
        XCTAssertEqual(account.email, "gedeon@gedeon.be")
        XCTAssertEqual(account.created?.timeIntervalSince1970, 1432097856.0)
    }
    
    func testBalance() {
        let balance: Balance = makeObject(fromFixturesWithName: "balance")
        XCTAssertEqual(balance.object, "balance")
        XCTAssertEqual(balance.live, false)
        XCTAssertEqual(balance.available, 380470)
        XCTAssertEqual(balance.total, 380470)
        XCTAssertEqual(balance.currency?.code, "THB")
    }
    
    func testBankAccount() {
        let bankAccount: BankAccount = makeObject(fromFixturesWithName: "bank_account")
        XCTAssertEqual(bankAccount.object, "bank_account")
        XCTAssertEqual(bankAccount.brand, "bbl")
        XCTAssertEqual(bankAccount.number, "1234567890")
        XCTAssertEqual(bankAccount.name, "SOMCHAI PRASERT")
        XCTAssertEqual(bankAccount.created?.timeIntervalSince1970, 1424944575.0)
    }
    
    func testCard() {
        let card: Card = makeObject(fromFixturesWithName: "card")
        XCTAssertEqual(card.object, "card")
        XCTAssertEqual(card.id, "card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(card.live, false)
        XCTAssertEqual(card.location, "/customers/cust_test_5086xleuh9ft4bn0ac2/cards/card_test_5086xl7amxfysl0ac5l")
        XCTAssertEqual(card.country, "us")
        XCTAssertEqual(card.city, "Bangkok")
        XCTAssertEqual(card.postalCode, "10320")
        XCTAssertEqual(card.financing, "")
        XCTAssertEqual(card.lastDigits?.lastDigits, "4242")
        XCTAssertEqual(card.brand?.rawValue, "Visa")

        XCTAssertEqual(card.expirationMonth, 10)
        XCTAssertEqual(card.expirationYear, 2018)
        XCTAssertEqual(card.fingerprint, "mKleiBfwp+PoJWB/ipngANuECUmRKjyxROwFW5IO7TM=")
        XCTAssertEqual(card.name, "Somchai Prasert")
        XCTAssertEqual(card.securityCodeCheck, true)
        XCTAssertEqual(card.created?.timeIntervalSince1970, 1433223706.0)
    }
    
    func testCharge() {
        let charge: Charge = makeObject(fromFixturesWithName: "charge")
        XCTAssertEqual(charge.object, "charge")
        XCTAssertEqual(charge.id, "chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(charge.status, ChargeStatus.successful)
        XCTAssertEqual(charge.live, false)
        XCTAssertEqual(charge.location, "/charges/chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(charge.amount, 100000)
        XCTAssertEqual(charge.currency?.code, "THB")
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
        let customer: Customer = makeObject(fromFixturesWithName: "customer")
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
        let dispute: Dispute = makeObject(fromFixturesWithName: "dispute")
        XCTAssertEqual(dispute.object, "dispute")
        XCTAssertEqual(dispute.id, "dspt_test_4zgf15h89w8t775kcm8")
        XCTAssertEqual(dispute.live, false)
        XCTAssertEqual(dispute.location, "/disputes/dspt_test_4zgf15h89w8t775kcm8")
        XCTAssertEqual(dispute.amount, 100000)
        XCTAssertEqual(dispute.currency?.code, "THB")
        XCTAssertEqual(dispute.status, DisputeStatus.pending)
        XCTAssertEqual(dispute.message, "This is an unauthorized transaction")
    }
    
    func testEvent() {
        let event: Event = makeObject(fromFixturesWithName: "event")
        XCTAssertEqual(event.object, "event")
        XCTAssertEqual(event.id, "evnt_test_526yctupnje5mbldskd")
        XCTAssertEqual(event.live, false)
        XCTAssertEqual(event.location, "/events/evnt_test_526yctupnje5mbldskd")
        XCTAssertEqual(event.key, "transfer.destroy")
        XCTAssertEqual(event.created?.timeIntervalSince1970, 1448854782.0)
        
        guard let transfer = event.data as? Transfer else { return XCTFail("data not deserialized into a Transfer") }
        XCTAssertEqual(transfer.object, "transfer")
        XCTAssertEqual(transfer.id, "trsf_test_526yctqob5djkckq88a")
    }
    
    func testRecipient() {
        let recipient: Recipient = makeObject(fromFixturesWithName: "recipient")
        XCTAssertEqual(recipient.object, "recipient")
        XCTAssertEqual(recipient.id, "recp_test_5086xmr74vxs0ajpo78")
        XCTAssertEqual(recipient.live, false)
        XCTAssertEqual(recipient.location, "/recipients/recp_test_5086xmr74vxs0ajpo78")
        XCTAssertEqual(recipient.verified, false)
        XCTAssertEqual(recipient.active, false)
        XCTAssertEqual(recipient.name, "Somchai Prasert")
        XCTAssertEqual(recipient.email, "somchai.prasert@example.com")
        XCTAssertEqual(recipient.recipientDescription, nil)
        XCTAssertEqual(recipient.type, RecipientType.individual)
        XCTAssertEqual(recipient.taxId, nil)
        XCTAssertEqual(recipient.failureCode, nil)
        XCTAssertEqual(recipient.created?.timeIntervalSince1970, 1433223713.0)
        
        guard let bankAccount = recipient.bankAccount else { return XCTFail("bank_account not deserialized") }
        XCTAssertEqual(bankAccount.object, "bank_account")
        XCTAssertEqual(bankAccount.brand, "bbl")
        XCTAssertEqual(bankAccount.lastDigits?.lastDigits, "7890")
    }
    
    func testRefund() {
        let refund: Refund = makeObject(fromFixturesWithName: "refund")
        XCTAssertEqual(refund.object, "refund")
        XCTAssertEqual(refund.id, "rfnd_test_5086xm1i7ddm3apeaev")
        XCTAssertEqual(refund.location, "/charges/chrg_test_5086xlsx4lghk9bpb75/refunds/rfnd_test_5086xm1i7ddm3apeaev")
        XCTAssertEqual(refund.amount, 20000)
        XCTAssertEqual(refund.currency?.code, "THB")
        XCTAssertEqual(refund.charge, "chrg_test_5086xlsx4lghk9bpb75")
        XCTAssertEqual(refund.transaction, "trxn_test_5086xm1mbshmohdhk00")
        XCTAssertEqual(refund.created?.timeIntervalSince1970, 1433223710.0)
    }
    
    func testToken() {
        let token: Token = makeObject(fromFixturesWithName: "token")
        XCTAssertEqual(token.object, "token")
        XCTAssertEqual(token.id, "tokn_test_5086xl7c9k5rnx35qba")
        XCTAssertEqual(token.live, false)
        XCTAssertEqual(token.used, false)
        XCTAssertEqual(token.location, "https://vault.omise.co/tokens/tokn_test_5086xl7c9k5rnx35qba")
        
        guard let card = token.card else { return XCTFail("card not deserialized") }
        XCTAssertEqual(card.object, "card")
        XCTAssertEqual(card.id, "card_test_5086xl7amxfysl0ac5l")
    }
    
    func testTransaction() {
        let transaction: Transaction = makeObject(fromFixturesWithName: "transaction")
        XCTAssertEqual(transaction.object, "transaction")
        XCTAssertEqual(transaction.id, "trxn_test_5086v66oxpujs6nll93")
        XCTAssertEqual(transaction.type, TransactionType.credit)
        XCTAssertEqual(transaction.amount, 96094)
        XCTAssertEqual(transaction.currency?.code, "THB")
        XCTAssertEqual(transaction.created?.timeIntervalSince1970, 1433223294.0)
    }
    
    func testTransfer() {
        let transfer: Transfer = makeObject(fromFixturesWithName: "transfer")
        XCTAssertEqual(transfer.object, "transfer")
        XCTAssertEqual(transfer.id, "trsf_test_5086uxn23hfaxv8nl0f")
        XCTAssertEqual(transfer.live, false)
        XCTAssertEqual(transfer.location, "/transfers/trsf_test_5086uxn23hfaxv8nl0f")
        XCTAssertEqual(transfer.recipient, "recp_test_506zyyammqke9tmhgh2")
        XCTAssertEqual(transfer.sent, false)
        XCTAssertEqual(transfer.paid, false)
        XCTAssertEqual(transfer.amount, 100000)
        XCTAssertEqual(transfer.failureCode, nil)
        XCTAssertEqual(transfer.failureMessage, nil)
        XCTAssertEqual(transfer.transaction, nil)
        XCTAssertEqual(transfer.created?.timeIntervalSince1970, 1433223253.0)
        
        guard let bankAccount = transfer.bankAccount else { return XCTFail("bank_account not deserialized") }
        XCTAssertEqual(bankAccount.object, "bank_account")
        XCTAssertEqual(bankAccount.brand, "test")
        XCTAssertEqual(bankAccount.lastDigits?.lastDigits, "6789")
        XCTAssertEqual(bankAccount.name, "DEFAULT BANK ACCOUNT")
    }
    
    fileprivate func makeObject<TObject: OmiseObject>(fromFixturesWithName name: String) -> TObject {
        let path = "Fixtures/objects/\(name)_object"
        guard let data = fixturesData(for: path) else {
            XCTFail("could not load fixtures path: \(path)")
            return TObject()
        }
        
        return try! OmiseSerializer.deserialize(data)
    }
}

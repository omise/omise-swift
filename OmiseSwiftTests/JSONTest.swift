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

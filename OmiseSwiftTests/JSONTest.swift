import Foundation
import XCTest
import Omise

class JSONTest: OmiseTestCase {
    func testAccount() {
        guard let data = fixturesDataFor("Fixtures/objects/account_object") else {
            return XCTFail("could not fixtures file.")
        }
        
        guard let jsonData = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) else {
            return XCTFail("fixture file maybe corrupt.")
        }
        
        guard let json = jsonData as? Model.Attributes else {
            return XCTFail("JSON deserialization failure.")
        }
        
        let account = Account(attributes: json)
        XCTAssertEqual(account.object, "account")
        XCTAssertEqual(account.id, "acct_4x7d2wtqnj2f4klrfsc")
        XCTAssertEqual(account.email, "gedeon@gedeon.be")
        XCTAssertEqual(account.created?.timeIntervalSince1970, 1432097856.0)
    }
}

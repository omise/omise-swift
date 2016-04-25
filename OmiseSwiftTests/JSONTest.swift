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
    
    private func buildFromFixtures<TModel: Model>(name: String, type: TModel.Type) -> TModel {
        guard let data = fixturesDataFor("Fixtures/objects/\(name)_object") else {
            XCTFail("could not fixtures file.")
            return TModel()
        }
        
        guard let jsonData = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) else {
            XCTFail("fixture file maybe corrupt.")
            return TModel()
        }
        
        guard let json = jsonData as? Model.Attributes else {
            XCTFail("JSON deserialization failure.")
            return TModel()
        }
        
        return TModel(attributes: json)
    }
}

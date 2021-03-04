import XCTest
import Omise

class CustomerOperationFixtureTests: FixtureTestCase {
    let customerTestingID: DataID<Customer>! = DataID(idString: "cust_test_5fz0olfpy32zadv96ek")
    
    func testCustomerRetrieve() {
        let expectation = self.expectation(description: "Customer result")
        
        let request = Customer.retrieve(using: testClient, id: customerTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customer):
                XCTAssertEqual(customer.id, self.customerTestingID)
                XCTAssertEqual(customer.location, "/customers/cust_test_5fz0olfpy32zadv96ek")
                XCTAssertFalse(customer.isLiveMode)
                XCTAssertEqual(customer.createdDate, dateFormatter.date(from: "2019-05-21T10:21:20Z"))
                XCTAssertEqual(customer.defaultCard?.id, "card_test_5fzbq7cypephj6fd3zq")
                XCTAssertEqual(customer.email, "john.doe@example.com")
                XCTAssertNotNil(customer.customerDescription)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

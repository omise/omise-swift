import XCTest
import Omise


private let cardTestingID = DataID<CustomerCard>(idString: "card_test_5fzbq7cypephj6fd3zq")!
private let customerTestingID = DataID<Customer>(idString: "cust_test_5fz0olfpy32zadv96ek")!

private let customer: Customer = {
    let bundle = Bundle(for: OmiseTestCase.self)
    guard let path = bundle.path(forResource: "Fixtures/api.omise.co/customers/cust_test_5fz0olfpy32zadv96ek-get",
                                 ofType: "json") else {
        XCTFail("could not load fixtures.")
        preconditionFailure()
    }
    
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
        XCTFail("could not load fixtures at path: \(path)")
        preconditionFailure()
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try! decoder.decode(Customer.self, from: data)
}()


class CustomerCardOperationFixtureTests: FixtureTestCase {
    func testCustomerRetrieve() {
        let expectation = self.expectation(description: "Customer result")
        let request = CustomerCard.retrieve(using: testClient, parent: customer, id: cardTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customer):
                XCTAssertEqual(customer.firstDigits.firstDigits, "424242")
                XCTAssertEqual(customer.lastDigits.lastDigits, "4242")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeCustomerRetrieve() throws {
        let defaultCustomer = try fixturesObjectFor(type: Customer.self, dataID: customerTestingID)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultCustomer)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCustomer = try decoder.decode(Customer.self, from: encodedData)
        XCTAssertEqual(defaultCustomer.object, decodedCustomer.object)
        XCTAssertEqual(defaultCustomer.id, decodedCustomer.id)
        XCTAssertEqual(defaultCustomer.location, decodedCustomer.location)
        XCTAssertEqual(defaultCustomer.email, decodedCustomer.email)
        XCTAssertEqual(defaultCustomer.defaultCard?.id, decodedCustomer.defaultCard?.id)
        XCTAssertEqual(defaultCustomer.isLiveMode, decodedCustomer.isLiveMode)
        XCTAssertEqual(defaultCustomer.isDeleted, decodedCustomer.isDeleted)
        XCTAssertEqual(defaultCustomer.createdDate, decodedCustomer.createdDate)
    }
    
    func testCustomerList() {
        let expectation = self.expectation(description: "Customer list")
        
        let request = CustomerCard.list(using: testClient, parent: customer, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customerCardsList):
                XCTAssertEqual(customerCardsList.count, 1)
                XCTAssertNotNil(customerCardsList.data)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testDeleteCard() {
        let expectation = self.expectation(description: "Customer Card Delete")
        
        
        let request = CustomerCard.list(using: testClient, parent: customer, params: nil) { (result) in
            defer { expectation.fulfill() }

            switch result {
            case let .success(customerCardsList):
                
                XCTAssertEqual(customerCardsList.count, 1)
                XCTAssertNotNil(customerCardsList.data)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
        
    }
}

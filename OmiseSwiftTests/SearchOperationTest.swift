import XCTest
@testable import Omise

class SearchOperationTest: OmiseTestCase {
    
    var testClient: Client {
        let config = Config(
            publicKey: "pkey_test_5570z4yt4wybjb03ag8",
            secretKey: "skey_test_5570z4yvwcr22l3rjnm",
            apiVersion: nil,
            queue: (OperationQueue.current ?? OperationQueue.main)
        )
        
        return Client(config: config)
    }
    
    func testSearchChargeByLastDigits() {
        let expectation = self.expectation(description: "transfer result")
        
        let searchParams = SearchParams<ChargeFilterParams>()
        searchParams.scope = Charge.scopeName
        let searchFilter = ChargeFilterParams()
        searchFilter.cardLastDigits = "1111"
        searchParams.filter = searchFilter
        
        let request = Charge.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charges):
                XCTAssertEqual(charges.data.count, 1)
                let samplingCharge = charges.data.first
                XCTAssertEqual(samplingCharge?.amount, 100000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testSearchChargeByCreatedDate() {
        let expectation = self.expectation(description: "transfer result")
        
        let searchParams = SearchParams<ChargeFilterParams>()
        searchParams.scope = Charge.scopeName
        var searchFilter = ChargeFilterParams()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2016
        dateComponents.month = 9
        dateComponents.day = 2
        searchFilter.created = dateComponents
        searchParams.filter = searchFilter
        
        let request = Charge.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charges):
                XCTAssertEqual(charges.data.count, 3)
                let samplingCharge = charges.data.first
                XCTAssertEqual(samplingCharge?.amount, 100000)
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testSearchCustomerByEmail() {
        let expectation = self.expectation(description: "transfer result")
        
        let searchParams = SearchParams<CustomerFilterParams>()
        searchParams.scope = Customer.scopeName
        var searchFilter = CustomerFilterParams()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2016
        dateComponents.month = 9
        dateComponents.day = 2
        searchFilter.created = dateComponents
        searchParams.filter = searchFilter
        searchParams.query = "john"
        
        let request = Customer.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customer):
                XCTAssertEqual(customer.data.count, 1)
                let samplingCustomer = customer.data.first
                XCTAssertEqual(samplingCustomer?.email, "john.doe@example.com")
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testSearchRecipientByKind() {
        let expectation = self.expectation(description: "transfer result")
        
        let searchParams = SearchParams<RecipientFilterParams>()
        searchParams.scope = Recipient.scopeName
        var searchFilter = RecipientFilterParams()
        searchFilter.type = .some(.individual)
        
        searchParams.filter = searchFilter
        
        let request = Recipient.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customer):
                XCTAssertEqual(customer.data.count, 1)
                let samplingCustomer = customer.data.first
                XCTAssertEqual(samplingCustomer?.email, "pitiphong@omise.co")
            case let .fail(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}

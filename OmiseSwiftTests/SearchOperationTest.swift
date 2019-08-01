import XCTest
@testable import Omise

class SearchOperationTest: LiveTest {
    
    func testSearchChargeByLastDigits() {
        let expectation = self.expectation(description: "transfer result")
        
        var searchParams = SearchParams(searhScopeType: Charge.self)
        var searchFilter = ChargeFilterParams()
        searchFilter.cardLastDigits = Digits(digitsString: "4242")!
        searchParams.filter = searchFilter
        
        let request = Charge.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charges):
                XCTAssertEqual(charges.data.count, 30)
                let samplingCharge = charges.data.first
                XCTAssertEqual(samplingCharge?.value.amount, 1_000_00)
            case let .failure(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    
    func testSearchChargeByCreatedDate() {
        let expectation = self.expectation(description: "transfer result")
        
        var searchParams = SearchParams(searhScopeType: Charge.self)
        var searchFilter = ChargeFilterParams()
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2017
        dateComponents.month = 1
        dateComponents.day = 5
        searchFilter.createdDate = dateComponents
        searchParams.filter = searchFilter
        
        let request = Charge.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(charges):
                XCTAssertEqual(charges.data.count, 2)
                let samplingCharge = charges.data.first
                XCTAssertEqual(samplingCharge?.value.amount, 100000)
            case let .failure(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testSearchCustomerByEmail() {
        let expectation = self.expectation(description: "transfer result")
        
        var searchParams = SearchParams(searhScopeType: Customer.self)
        searchParams.scope = Customer.scopeName
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar(identifier: .gregorian)
        dateComponents.year = 2016
        dateComponents.month = 9
        dateComponents.day = 2
        var searchFilter = CustomerFilterParams(createdDate: dateComponents)
        searchParams.filter = searchFilter
        searchParams.query = "john"
        
        let request = Customer.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customer):
                XCTAssertEqual(customer.data.count, 1)
                let samplingCustomer = customer.data.first
                XCTAssertEqual(samplingCustomer?.email, "john.doe@example.com")
            case let .failure(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testSearchRecipientByKind() {
        let expectation = self.expectation(description: "transfer result")
        
        var searchParams = SearchParams(searhScopeType: Recipient.self)
        searchParams.scope = Recipient.scopeName
        var searchFilter = RecipientFilterParams(type: .individual)
        
        searchParams.filter = searchFilter
        
        let request = Recipient.search(using: testClient, params: searchParams, callback: { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(customer):
                XCTAssertEqual(customer.data.count, 1)
                let samplingCustomer = customer.data.first
                XCTAssertEqual(samplingCustomer?.email, "john.doe@example.com")
            case let .failure(error):
                XCTFail("\(error)")
            }
        })
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}

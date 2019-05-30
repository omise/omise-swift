import XCTest
@testable import Omise


class CapabilityOperationFixtureTests: FixtureTestCase {
    func testCapabilityRetrieve() {
        let expectation = self.expectation(description: "Capability result")

        let request = Capability.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(capability):
                XCTAssertEqual(capability.supportedMethods.count, 6)
                
                if let creditCardMethod = capability.creditCardMethod {
                    XCTAssertEqual(creditCardMethod.payment, .card([]))
                    XCTAssertEqual(creditCardMethod.supportedCurrencies, [.thb, .jpy, .usd, .eur, .gbp, .sgd])
                } else {
                    XCTFail("Capability doesn't have the Credit Card backend")
                }
                
                if let bayInstallmentMethod = capability[SourceType.installment(.bay)] {
                    XCTAssertEqual(
                        bayInstallmentMethod.payment,
                        .installment(.bay, availableNumberOfTerms: IndexSet(arrayLiteral: 3, 4, 6, 9, 10))
                    )
                    XCTAssertEqual(bayInstallmentMethod.supportedCurrencies, [.thb])
                } else {
                    XCTFail("Capability doesn't have the BAY Installment backend")
                }
                
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 100_00, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 6))
                    )
                    XCTAssertTrue(capability ~= chargeParams)
                }
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 10_00, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 6))
                    )
                    XCTAssertTrue(capability ~= chargeParams)
                }
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 100_000_000_00, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 6))
                    )
                    XCTAssertTrue(capability ~= chargeParams)
                }
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 100_00, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 5))
                    )
                    XCTAssertFalse(capability ~= chargeParams)
                }
                
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 100_00, currency: .thb),
                        cardID: "card_test_123456789abcd"
                    )
                    XCTAssertTrue(capability ~= chargeParams)
                }
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeCapabilityRetrieve() throws {
        let capability = try fixturesObjectFor(type: Capability.self)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(capability)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCapability = try decoder.decode(Capability.self, from: encodedData)
        
        XCTAssertEqual(capability.supportedMethods.count, decodedCapability.supportedMethods.count)
        
        XCTAssertEqual(capability.creditCardMethod?.payment, decodedCapability.creditCardMethod?.payment)
        XCTAssertEqual(capability.creditCardMethod?.supportedCurrencies,
                       decodedCapability.creditCardMethod?.supportedCurrencies)
        XCTAssertEqual(
            capability[SourceType.installment(.bay)]?.payment,
            decodedCapability[SourceType.installment(.bay)]?.payment
        )
        XCTAssertEqual(capability[SourceType.installment(.bay)]?.supportedCurrencies,
                       decodedCapability[SourceType.installment(.bay)]?.supportedCurrencies)
    }
}


import XCTest
@testable import Omise

// swiftlint:disable closure_body_length function_body_length
class CapabilityOperationFixtureTests: FixtureTestCase {
    func testCapabilityRetrieve() {
        let expectation = self.expectation(description: "Capability result")

        let request = Capability.retrieve(using: testClient) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(capability):
                XCTAssertEqual(capability.supportedMethods.count, 17)
                
                if let creditCardMethod = capability.creditCardMethod {
                    XCTAssertEqual(creditCardMethod.payment, .card([]))
                    XCTAssertEqual(creditCardMethod.supportedCurrencies,
                                   [.thb, .jpy, .usd, .eur, .gbp, .sgd, .aud, .chf, .cny, .dkk, .hkd])
                } else {
                    XCTFail("Capability doesn't have the Credit Card backend")
                }
                
                if let fpxMethod = capability[SourceType.fpx] {
                    let firstBank = fpxMethod.banks[0]

                    XCTAssertTrue(firstBank.isActive)
                    XCTAssertEqual(firstBank.name, "KFH")
                    XCTAssertEqual(firstBank.code, "kfh")
                } else {
                    XCTFail("Capability doesn't have the FPX backend")
                }
                
                if let bayInstallmentMethod = capability[SourceType.installment(.bay)] {
                    XCTAssertEqual(
                        bayInstallmentMethod.payment,
                        .installment(.bay, availableNumberOfTerms: IndexSet([3, 4, 6, 9, 10])))
                    XCTAssertEqual(bayInstallmentMethod.supportedCurrencies, [.thb])
                } else {
                    XCTFail("Capability doesn't have the BAY Installment backend")
                }
                
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 10_000, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 6)))
                    XCTAssertTrue(capability ~= chargeParams)
                }
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 1000, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 6)))
                    XCTAssertTrue(capability ~= chargeParams)
                }
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 10_000_000_000, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 6)))
                    XCTAssertTrue(capability ~= chargeParams)
                }
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 10_000, currency: .thb),
                        sourceType: .installment(Installment.CreateParameter(brand: .bay, numberOfTerms: 5)))
                    XCTAssertFalse(capability ~= chargeParams)
                }
                
                do {
                    let chargeParams = ChargeParams(
                        value: Value(amount: 10_000, currency: .thb),
                        cardID: "tokn_test_123456789abcd")
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
            capability[SourceType.fpx]?.banks,
            decodedCapability[SourceType.fpx]?.banks)
        XCTAssertEqual(
            capability[SourceType.installment(.bay)]?.payment,
            decodedCapability[SourceType.installment(.bay)]?.payment)
        XCTAssertEqual(capability[SourceType.installment(.bay)]?.supportedCurrencies,
                       decodedCapability[SourceType.installment(.bay)]?.supportedCurrencies)
    }
}

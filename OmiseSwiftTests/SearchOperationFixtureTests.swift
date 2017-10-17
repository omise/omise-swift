import XCTest
@testable import Omise


class SearchOperationFixtureTests: FixtureTestCase {
    
    static let dateComponents: DateComponents = {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.calendar = calendar
        return dateComponents
    }()
    
    func testEncodeChargeFilterParams() throws {
        let filterParams = ChargeFilterParams(
            amount: 1000.00, isAuthorized: true,
            isAutoCapture: false, isCaptured: true,
            capturedDate: SearchOperationFixtureTests.dateComponents,
            cardLastDigits: LastDigits(lastDigitsString: "4242"),
            createdDate: SearchOperationFixtureTests.dateComponents, isCustomerPresent: true,
            failureCode: ChargeFailure.Code.amountMismatch, failureMessage: "Failure Message",
            isRefunded: false, refundedAmount: 500.0,
            isReversed: nil, status: .successful,
            sourceOfFund: .card, isVoided: nil
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedChargeFilterParams = try decoder.decode(ChargeFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.amount, decodedChargeFilterParams.amount)
        XCTAssertEqual(filterParams.isAuthorized, decodedChargeFilterParams.isAuthorized)
        XCTAssertEqual(filterParams.isAutoCapture, decodedChargeFilterParams.isAutoCapture)
        XCTAssertEqual(filterParams.isCaptured, decodedChargeFilterParams.isCaptured)
        XCTAssertEqual(filterParams.capturedDate, decodedChargeFilterParams.capturedDate)
        XCTAssertEqual(filterParams.cardLastDigits, decodedChargeFilterParams.cardLastDigits)
        XCTAssertEqual(filterParams.createdDate, decodedChargeFilterParams.createdDate)
        XCTAssertEqual(filterParams.isCustomerPresent, decodedChargeFilterParams.isCustomerPresent)
        XCTAssertEqual(filterParams.failureCode, decodedChargeFilterParams.failureCode)
        XCTAssertEqual(filterParams.failureMessage, decodedChargeFilterParams.failureMessage)
        XCTAssertEqual(filterParams.isRefunded, decodedChargeFilterParams.isRefunded)
        XCTAssertEqual(filterParams.refundedAmount, decodedChargeFilterParams.refundedAmount)
        XCTAssertEqual(filterParams.isReversed, decodedChargeFilterParams.isReversed)
        XCTAssertEqual(filterParams.status, decodedChargeFilterParams.status)
        XCTAssertEqual(filterParams.sourceOfFund, decodedChargeFilterParams.sourceOfFund)
        XCTAssertEqual(filterParams.isVoided, decodedChargeFilterParams.isVoided)
    }
    
    
    func testEncodeRefundFilterParams() throws {
        let filterParams = RefundFilterParams(
            amount: 1000.00, cardLastDigits: LastDigits(lastDigitsString: "4242"),
            createdDate: SearchOperationFixtureTests.dateComponents, isVoided: false
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedFilterParams = try decoder.decode(RefundFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.amount, decodedFilterParams.amount)
        XCTAssertEqual(filterParams.cardLastDigits, decodedFilterParams.cardLastDigits)
        XCTAssertEqual(filterParams.createdDate, decodedFilterParams.createdDate)
        XCTAssertEqual(filterParams.isVoided, decodedFilterParams.isVoided)
    }
    
    
    func testEncodeDisputeFilterParams() throws {
        let filterParams = DisputeFilterParams(
            amount: 1000.00, cardLastDigits: LastDigits(lastDigitsString: "4242"),
            closedDate: SearchOperationFixtureTests.dateComponents,
            createdDate: SearchOperationFixtureTests.dateComponents,
            currency: .thb,
            status: DisputeStatus.open
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedDisputedFilterParams = try decoder.decode(DisputeFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.amount, decodedDisputedFilterParams.amount)
        XCTAssertEqual(filterParams.cardLastDigits, decodedDisputedFilterParams.cardLastDigits)
        XCTAssertEqual(filterParams.closedDate, decodedDisputedFilterParams.closedDate)
        XCTAssertEqual(filterParams.createdDate, decodedDisputedFilterParams.createdDate)
        XCTAssertEqual(filterParams.currency, decodedDisputedFilterParams.currency)
        XCTAssertEqual(filterParams.status, decodedDisputedFilterParams.status)
    }
    
    
    func testEncodeRecipientFilterParams() throws {
        let filterParams = RecipientFilterParams(
            isActive: false, activatedDate: SearchOperationFixtureTests.dateComponents,
            bankLastDigits: LastDigits(lastDigitsString: "4242"),
            isDeleted: true, type: RecipientType.individual
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedRecipientFilterParams = try decoder.decode(RecipientFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.isActive, decodedRecipientFilterParams.isActive)
        XCTAssertEqual(filterParams.activatedDate, decodedRecipientFilterParams.activatedDate)
        XCTAssertEqual(filterParams.bankLastDigits, decodedRecipientFilterParams.bankLastDigits)
        XCTAssertEqual(filterParams.isDeleted, decodedRecipientFilterParams.isDeleted)
        XCTAssertEqual(filterParams.type, decodedRecipientFilterParams.type)
    }
    
    
    func testEncodeCustomerFilterParams() throws {
        let filterParams = CustomerFilterParams(
            createdDate: SearchOperationFixtureTests.dateComponents
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedCustomerFilterParams = try decoder.decode(CustomerFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.createdDate, decodedCustomerFilterParams.createdDate)
    }
    
    
    func testEncodeLinkFilterParams() throws {
        let filterParams = LinkFilterParams(
            amount: 1000.00,
            created: SearchOperationFixtureTests.dateComponents,
            isMultiple: false, isUsed: true,
            usedDate: SearchOperationFixtureTests.dateComponents
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedLinkFilterParams = try decoder.decode(LinkFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.amount, decodedLinkFilterParams.amount)
        XCTAssertEqual(filterParams.created, decodedLinkFilterParams.created)
        XCTAssertEqual(filterParams.isMultiple, decodedLinkFilterParams.isMultiple)
        XCTAssertEqual(filterParams.isUsed, decodedLinkFilterParams.isUsed)
        XCTAssertEqual(filterParams.usedDate, decodedLinkFilterParams.usedDate)
    }
    
    
    func testEncodeTransferFilterParams() throws {
        let filterParams = TransferFilterParams(
            amount: 1000.00,
            created: SearchOperationFixtureTests.dateComponents,
            isDeleted: true,
            fee: 500.0,
            isPaid: true, paidDate: SearchOperationFixtureTests.dateComponents,
            isSent: false, sentDate: SearchOperationFixtureTests.dateComponents
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(filterParams)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedTransferFilterParams = try decoder.decode(TransferFilterParams.self, from: encodedData)
        
        XCTAssertEqual(filterParams.amount, decodedTransferFilterParams.amount)
        XCTAssertEqual(filterParams.created, decodedTransferFilterParams.created)
        XCTAssertEqual(filterParams.isDeleted, decodedTransferFilterParams.isDeleted)
        XCTAssertEqual(filterParams.fee, decodedTransferFilterParams.fee)
        XCTAssertEqual(filterParams.isPaid, decodedTransferFilterParams.isPaid)
        XCTAssertEqual(filterParams.paidDate, decodedTransferFilterParams.paidDate)
        XCTAssertEqual(filterParams.isSent, decodedTransferFilterParams.isSent)
        XCTAssertEqual(filterParams.sentDate, decodedTransferFilterParams.sentDate)
    }
    
    
}

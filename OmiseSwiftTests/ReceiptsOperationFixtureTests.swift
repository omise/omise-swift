import XCTest
import Omise


private let receiptTestingID = "rcpt_test_12345"


class ReceiptsOperationFixtureTests: FixtureTestCase {
    
    func testReceiptRetrieve() {
        let expectation = self.expectation(description: "Receipt result")
        
        let request = Receipt.retrieve(using: testClient, id: receiptTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(receipt):
                XCTAssertEqual(receipt.number, "OMTH201903110001")
                XCTAssertNil(receipt.customerName)
                XCTAssertEqual(receipt.customerTaxID, "123456")
                XCTAssertNil(receipt.customerEmail)
                XCTAssertNil(receipt.customerStatementName)
                
                XCTAssertEqual(receipt.companyName, "Omise Company Limited")
                XCTAssertEqual(receipt.companyTaxID, "0105556091152")
                
                XCTAssertEqual(receipt.chargeFee, 0)
                XCTAssertEqual(receipt.voidedFee, 0)
                XCTAssertEqual(receipt.transferFee, 0)
                XCTAssertEqual(receipt.feeSubtotal, 1460000)
                XCTAssertEqual(receipt.vat, 102200)
                XCTAssertEqual(receipt.wht, 0)
                XCTAssertEqual(receipt.total, 1562200)
                XCTAssertEqual(receipt.issuedDateComponents, DateComponents(calendar: Calendar(identifier: .gregorian), year: 2019, month: 3, day: 11))
                XCTAssertEqual(receipt.currency, .thb)
                XCTAssertFalse(receipt.isCreditNote)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeReceiptRetrieve() throws {
        let defaultReceipt = try fixturesObjectFor(type: Receipt.self, dataID: receiptTestingID)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultReceipt)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedReceipt = try decoder.decode(Receipt.self, from: encodedData)
        XCTAssertEqual(defaultReceipt.object, decodedReceipt.object)
        XCTAssertEqual(defaultReceipt.id, decodedReceipt.id)
        XCTAssertEqual(defaultReceipt.number, decodedReceipt.number)
        XCTAssertEqual(defaultReceipt.location, decodedReceipt.location)
        XCTAssertEqual(defaultReceipt.issuedDateComponents, decodedReceipt.issuedDateComponents)
        XCTAssertEqual(defaultReceipt.customerName, decodedReceipt.customerName)
        XCTAssertEqual(defaultReceipt.customerAddress, decodedReceipt.customerAddress)
        XCTAssertEqual(defaultReceipt.customerTaxID, decodedReceipt.customerTaxID)
        XCTAssertEqual(defaultReceipt.customerEmail, decodedReceipt.customerEmail)
        XCTAssertEqual(defaultReceipt.customerStatementName, decodedReceipt.customerStatementName)
        XCTAssertEqual(defaultReceipt.companyName, decodedReceipt.companyName)
        XCTAssertEqual(defaultReceipt.companyAddress, decodedReceipt.companyAddress)
        XCTAssertEqual(defaultReceipt.companyTaxID, decodedReceipt.companyTaxID)
        XCTAssertEqual(defaultReceipt.chargeFee, decodedReceipt.chargeFee)
        XCTAssertEqual(defaultReceipt.voidedFee, decodedReceipt.voidedFee)
        XCTAssertEqual(defaultReceipt.transferFee, decodedReceipt.transferFee)
        XCTAssertEqual(defaultReceipt.feeSubtotal, decodedReceipt.feeSubtotal)
        XCTAssertEqual(defaultReceipt.vat, decodedReceipt.vat)
        XCTAssertEqual(defaultReceipt.wht, decodedReceipt.wht)
        XCTAssertEqual(defaultReceipt.total, decodedReceipt.total)
        XCTAssertEqual(defaultReceipt.isCreditNote, decodedReceipt.isCreditNote)
        XCTAssertEqual(defaultReceipt.currency, decodedReceipt.currency)
    }
    
    func testReceiptList() {
        let expectation = self.expectation(description: "Receipt list")
        
        let request = Receipt.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(receiptsList):
                XCTAssertNotNil(receiptsList.data)
                XCTAssertEqual(receiptsList.data.count, 1)
                let receiptSampleData = receiptsList.data.first
                XCTAssertNotNil(receiptSampleData)
                
                XCTAssertEqual(receiptSampleData?.number, "OMTH201903110001")
                XCTAssertNil(receiptSampleData?.customerName)
                XCTAssertEqual(receiptSampleData?.customerTaxID, "123456")
                XCTAssertNil(receiptSampleData?.customerEmail)
                XCTAssertNil(receiptSampleData?.customerStatementName)
                
                XCTAssertEqual(receiptSampleData?.companyName, "Omise Company Limited")
                XCTAssertEqual(receiptSampleData?.companyTaxID, "0105556091152")
                
                XCTAssertEqual(receiptSampleData?.chargeFee, 0)
                XCTAssertEqual(receiptSampleData?.voidedFee, 0)
                XCTAssertEqual(receiptSampleData?.transferFee, 0)
                XCTAssertEqual(receiptSampleData?.feeSubtotal, 1460000)
                XCTAssertEqual(receiptSampleData?.vat, 102200)
                XCTAssertEqual(receiptSampleData?.wht, 0)
                XCTAssertEqual(receiptSampleData?.total, 1562200)
                XCTAssertEqual(receiptSampleData?.issuedDateComponents, DateComponents(calendar: Calendar(identifier: .gregorian), year: 2019, month: 3, day: 11))
                XCTAssertEqual(receiptSampleData?.currency, .thb)
                XCTAssertEqual(receiptSampleData?.isCreditNote, false)

            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}

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
                XCTAssertEqual(receipt.number, "1")
                XCTAssertEqual(receipt.customerName, "John Doe")
                XCTAssertEqual(receipt.customerTaxID, "Tax ID 1234")
                XCTAssertEqual(receipt.customerEmail, "john@omise.co")
                XCTAssertEqual(receipt.customerStatementName, "John")
                
                XCTAssertEqual(receipt.companyName, "Omise Company Limited")
                XCTAssertEqual(receipt.companyTaxID, "0105556091152")
                
                XCTAssertEqual(receipt.chargeFee, 3650)
                XCTAssertEqual(receipt.voidedFee, 0)
                XCTAssertEqual(receipt.transferFee, 0)
                XCTAssertEqual(receipt.feeSubtotal, 3650)
                XCTAssertEqual(receipt.vat, 256)
                XCTAssertEqual(receipt.wht, 0)
                XCTAssertEqual(receipt.total, 3906)
                XCTAssertEqual(receipt.date, dateFormatter.date(from: "2017-07-13T16:59:59Z"))
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
        XCTAssertEqual(defaultReceipt.date, decodedReceipt.date)
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
                
                XCTAssertEqual(receiptSampleData?.number, "1")
                XCTAssertEqual(receiptSampleData?.customerName, "John Doe")
                XCTAssertEqual(receiptSampleData?.customerTaxID, "Tax ID 1234")
                XCTAssertEqual(receiptSampleData?.customerEmail, "john@omise.co")
                XCTAssertEqual(receiptSampleData?.customerStatementName, "John")
                
                XCTAssertEqual(receiptSampleData?.companyName, "Omise Company Limited")
                XCTAssertEqual(receiptSampleData?.companyTaxID, "0105556091152")
                
                XCTAssertEqual(receiptSampleData?.chargeFee, 3650)
                XCTAssertEqual(receiptSampleData?.voidedFee, 0)
                XCTAssertEqual(receiptSampleData?.transferFee, 0)
                XCTAssertEqual(receiptSampleData?.feeSubtotal, 3650)
                XCTAssertEqual(receiptSampleData?.vat, 256)
                XCTAssertEqual(receiptSampleData?.wht, 0)
                XCTAssertEqual(receiptSampleData?.total, 3906)
                XCTAssertEqual(receiptSampleData?.date, dateFormatter.date(from: "2017-07-13T16:59:59Z"))
                XCTAssertEqual(receiptSampleData?.currency, .thb)
                XCTAssertEqual(receiptSampleData?.isCreditNote, false)

            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
}

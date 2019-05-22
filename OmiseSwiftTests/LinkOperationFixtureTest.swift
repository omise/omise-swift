import XCTest
import Omise

private let linkTestingID = "link_test_5bh0ji63ctfk4gug2d5"

class LinkOperationFixtureTest: FixtureTestCase {
    func testLinkRetrieve() {
        let expectation = self.expectation(description: "Link result")
        
        let request = Link.retrieve(using: testClient, id: linkTestingID) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(link):
                XCTAssertEqual(link.value.amount, 120000)
                XCTAssertEqual(link.charges.total, 1)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testEncodeLinkRetrieve() throws {
        let defaultLink = try fixturesObjectFor(type: Link.self, dataID: linkTestingID)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let encodedData = try encoder.encode(defaultLink)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let decodedLink = try decoder.decode(Link.self, from: encodedData)
        XCTAssertEqual(defaultLink.object, decodedLink.object)
        XCTAssertEqual(defaultLink.id, decodedLink.id)
        XCTAssertEqual(defaultLink.isLiveMode, decodedLink.isLiveMode)
        XCTAssertEqual(defaultLink.location, decodedLink.location)
        XCTAssertEqual(defaultLink.amount, decodedLink.amount)
        XCTAssertEqual(defaultLink.currency, decodedLink.currency)
        XCTAssertEqual(defaultLink.isUsed, decodedLink.isUsed)
        XCTAssertEqual(defaultLink.isMultiple, decodedLink.isMultiple)
        XCTAssertEqual(defaultLink.title, decodedLink.title)
        XCTAssertEqual(defaultLink.linkDescription, decodedLink.linkDescription)
        XCTAssertEqual(defaultLink.paymentURL, decodedLink.paymentURL)
        XCTAssertEqual(defaultLink.createdDate, decodedLink.createdDate)
        
        XCTAssertEqual(defaultLink.charges.object, decodedLink.charges.object)
        XCTAssertEqual(defaultLink.charges.from, decodedLink.charges.from)
        XCTAssertEqual(defaultLink.charges.to, decodedLink.charges.to)
        XCTAssertEqual(defaultLink.charges.offset, decodedLink.charges.offset)
        XCTAssertEqual(defaultLink.charges.limit, decodedLink.charges.limit)
        XCTAssertEqual(defaultLink.charges.count, decodedLink.charges.count)
        XCTAssertEqual(defaultLink.charges.data.count, decodedLink.charges.data.count)
        
        guard let defaultCharge = defaultLink.charges.data.first, let decodedCharge = decodedLink.charges.data.first else {
            XCTFail("Cannot get the recent charge")
            return
        }
        
        XCTAssertEqual(defaultCharge.object, decodedCharge.object)
        XCTAssertEqual(defaultCharge.id, decodedCharge.id)
        XCTAssertEqual(defaultCharge.isLiveMode, decodedCharge.isLiveMode)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.amount, decodedCharge.amount)
        XCTAssertEqual(defaultCharge.currency, decodedCharge.currency)
        XCTAssertEqual(defaultCharge.chargeDescription, decodedCharge.chargeDescription)
        XCTAssertEqual(defaultCharge.status, decodedCharge.status)
        XCTAssertEqual(defaultCharge.isAutoCapture, decodedCharge.isAutoCapture)
        XCTAssertEqual(defaultCharge.isAuthorized, decodedCharge.isAuthorized)
        XCTAssertEqual(defaultCharge.isPaid, decodedCharge.isPaid)
        XCTAssertEqual(defaultCharge.transaction?.dataID, decodedCharge.transaction?.dataID)
        XCTAssertEqual(defaultCharge.source?.id, decodedCharge.source?.id)
        XCTAssertEqual(defaultCharge.location, decodedCharge.location)
        XCTAssertEqual(defaultCharge.returnURL, decodedCharge.returnURL)
        XCTAssertEqual(defaultCharge.authorizedURL, decodedCharge.authorizedURL)
        
        XCTAssertEqual(defaultCharge.card, decodedCharge.card)
        XCTAssertEqual(defaultCharge.card?.object, decodedCharge.card?.object)
        XCTAssertEqual(defaultCharge.card?.id, decodedCharge.card?.id)
        XCTAssertEqual(defaultCharge.card?.isLiveMode, decodedCharge.card?.isLiveMode)
        XCTAssertEqual(defaultCharge.card?.countryCode, decodedCharge.card?.countryCode)
        XCTAssertEqual(defaultCharge.card?.lastDigits, decodedCharge.card?.lastDigits)
        XCTAssertEqual(defaultCharge.card?.brand.rawValue, decodedCharge.card?.brand.rawValue)
        XCTAssertEqual(defaultCharge.card?.expiration?.month, decodedCharge.card?.expiration?.month)
        XCTAssertEqual(defaultCharge.card?.expiration?.year, decodedCharge.card?.expiration?.year)
        XCTAssertEqual(defaultCharge.card?.fingerPrint, decodedCharge.card?.fingerPrint)
        XCTAssertEqual(defaultCharge.card?.name, decodedCharge.card?.name)
        XCTAssertEqual(defaultCharge.card?.createdDate, decodedCharge.card?.createdDate)
        XCTAssertEqual(defaultCharge.card?.bankName, decodedCharge.card?.bankName)
        
        XCTAssertEqual(defaultCharge.ipAddress, decodedCharge.ipAddress)
        XCTAssertEqual(defaultCharge.createdDate, decodedCharge.createdDate)
    }
    
    func testLinkList() {
        let expectation = self.expectation(description: "Link list")
        
        let request = Link.list(using: testClient, params: nil) { (result) in
            defer { expectation.fulfill() }
            
            switch result {
            case let .success(linksList):
                XCTAssertNotNil(linksList.data)
                XCTAssertEqual(linksList.data.count, 6)
                let linkSampleData = linksList.data.first
                XCTAssertNotNil(linkSampleData)
                XCTAssertEqual(linkSampleData?.value.amount, 20000)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}

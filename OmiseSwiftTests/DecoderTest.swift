import XCTest
@testable import Omise


struct MetadataDummy: Decodable {
    
    let metadata: [String: Any]
    
    private enum CodingKeys: String, CodingKey {
        case metadata
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
    }
}

class DecodeTests: XCTestCase {
    
    func jsonData(withFileName name: String) throws -> Data {
        let bundle = Bundle(for: FixtureClient.self)
        let directoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!
        let filePath = (name as NSString).appendingPathExtension("json")! as String
        let fixtureFileURL = directoryURL.appendingPathComponent(filePath)
        return try Data(contentsOf: fixtureFileURL)
    }
    
    func testAnyJSONTypeDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "metadata")
            let decodedData = try JSONDecoder().decode(MetadataDummy.self, from: jsonData)
            let metadata = decodedData.metadata
            XCTAssertEqual(metadata["a_string"] as? String, "some_string")
            XCTAssertEqual(metadata["an_integer"] as? Int, 1)
            XCTAssertEqual(metadata["a_bool"] as? Bool, true)
            XCTAssertEqual(metadata["a_double"] as? Double, 12.34)
            guard let object: [String: Any] = metadata["an_object"] as? [String: Any] else {
                XCTFail("could not decode object")
                return
            }
            XCTAssertEqual(object["a_key"] as? String, "a_value")
            guard let nestedObject: [String: Any] = object["a_nested_object"] as? [String: Any] else {
                XCTFail("Could not decode nested object")
                return
            }
            XCTAssertEqual(nestedObject["a_nested_key"] as? String, "a_nested_value")
            guard let array: [Any] = metadata["an_array"] as? [Any] else {
                XCTFail("Could not decode array")
                return
            }
            XCTAssertTrue(array.count == 2)
            XCTAssertEqual(array[0] as? String, "value_1")
            XCTAssertEqual(array[1] as? String, "value_2")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }
    
    @available(iOS 11.0, *)
    func testTokenParamEncoding() throws {
        let params = TokenParams(number: "4242424242424242", name: "John Doe", expiration: (12, 2020), securityCode: "123", billingAddress: BillingAddress(street1: "123 Main Road", street2: nil, city: "Bangkok", state: nil, postalCode: "10240", countryCode: nil, phoneNumber: "7777777777"))
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        
        let encodedData = try encoder.encode(params)
        
        let jsonData = try self.jsonData(withFileName: "token-params")
        XCTAssertEqual(jsonData, encodedData)
    }
}


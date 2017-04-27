import XCTest
@testable import Omise

class FixtureTestCase: OmiseTestCase {
    var testClient: FixtureClient {
        let testingApplicationKeyJSON = [
            "kind": "application",
            "name": "iOS Test Case",
            "object": "key",
            "key": "akey_test_57rqqo973wulbfhpqgq",
            "id": "key_test_57rqqo999mo107dacao",
            "livemode": false,
            "created": "2017-04-26T12:06:34Z"
            ] as [String : Any]
        let config = APIConfiguration(applicationKey: Key<ApplicationKey>(JSON: testingApplicationKeyJSON)!)
        return FixtureClient(config: config)
    }
    
    func fixturesData(for filename: String) -> Data? {
        let bundle = Bundle(for: OmiseTestCase.self)
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            XCTFail("could not load fixtures.")
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("could not load fixtures at path: \(path)")
            return nil
        }
        
        return data
    }
}

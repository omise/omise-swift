import Foundation
import XCTest
import Omise

class LiveTest: OmiseTestCase {
    var testClient: APIClient {
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
        return APIClient(config: config)
    }
}

import Foundation
import XCTest
import Omise

class LiveTest: OmiseTestCase {
    var testClient: APIClient {
        let config = APIConfiguration(key: AnyKey("akey_test_57rqqo973wulbfhpqgq"))
        return APIClient(config: config)
    }
}

import Foundation
import XCTest
import Omise

class LiveTest: OmiseTestCase {
    var testClient: APIClient {
        let config = APIConfiguration(key: AnyAccessKey("skey_test_58wfnlwq0pxte1cvbqx"))
        return APIClient(config: config)
    }
}

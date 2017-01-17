import XCTest
@testable import Omise

class FixtureTestCase: OmiseTestCase {
    var testClient: FixtureClient {
        let config = APIConfiguration(
            apiVersion: "2015-11-17",
            publicKey: "pkey_test_5511txgnw3t6tqqlf0v",
            secretKey: "skey_test_5511tympbgf8im3jhjv"
        )
        
        return FixtureClient(config: config)
    }
}

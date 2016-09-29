import XCTest
@testable import Omise

class FixtureTestCase: OmiseTestCase {
    var testClient: FixtureClient {
        let config = Config(
            publicKey: "pkey_test_5511txgnw3t6tqqlf0v",
            secretKey: "skey_test_5511tympbgf8im3jhjv",
            apiVersion: nil,
            queue: (OperationQueue.current ?? OperationQueue.main)
        )
        
        return FixtureClient(config: config)
    }
}

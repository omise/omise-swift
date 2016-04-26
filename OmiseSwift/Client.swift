import Foundation

public class Client: NSObject {
    let sessionIdentifier = "omise.co"
    
    private var session: NSURLSession?
    private var queue: NSOperationQueue?
    
    override init() {
        super.init()
        self.queue = NSOperationQueue()
        self.session = NSURLSession(
            configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(),
            delegate: nil,
            delegateQueue: queue)
    }
}

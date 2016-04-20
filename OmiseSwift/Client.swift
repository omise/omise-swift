import Foundation

public class Client: NSObject {
    let sessionIdentifier = "omise.co"
    
    private var requests: [Int: Request] = [:]
    private var session: NSURLSession?
    private var queue: NSOperationQueue?
    
    override init() {
        super.init()
        queue = NSOperationQueue()
        session = NSURLSession(
            configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(),
            delegate: nil,
            delegateQueue: queue)
    }
}

extension Client: NSURLSessionTaskDelegate {
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        // let request = requests[task.taskIdentifier]
    }
}
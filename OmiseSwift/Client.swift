import Foundation

public class Client: NSObject {
    public static let sessionIdentifier = "omise.co"
    
    private var session: NSURLSession?
    private var queue: NSOperationQueue?
    
    public let config: Config
    
    public init(config: Config) {
        self.config = config
        super.init()
        
        self.queue = NSOperationQueue()
        self.session = NSURLSession(
            configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(),
            delegate: nil,
            delegateQueue: queue)
    }
    
    public func call<TOperation: Operation where TOperation.Result: OmiseObject>(operation: TOperation, callback: Request<TOperation>.Callback) -> Request<TOperation>? {
        guard let session = self.session else {
            NSLog("url session initialization failure.")
            return nil
        }
        
        guard let req: Request<TOperation> = Request(config: config, session: session, operation: operation) else {
            NSLog("request initialization failure.")
            return nil
        }
        
        return req.startWithCallback(callback)
    }
}

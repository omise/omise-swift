import Foundation

public class Client: NSObject {
    public static let sessionIdentifier = "omise.co"
    
    let session: NSURLSession
    let operationQueue: NSOperationQueue
    
    public let config: Config
    
    public init(config: Config) {
        self.config = config
        
        self.operationQueue = NSOperationQueue()
        self.session = NSURLSession(
            configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(),
            delegate: nil,
            delegateQueue: operationQueue)
        super.init()
    }
    
    public func call<TResult: OmiseObject>(operation: Operation<TResult>, callback: Operation<TResult>.Callback?) -> Request<TResult>? {
        do {
            let req: Request<TResult> = Request(client: self, operation: operation, callback: callback)
            return try req.start()
            
        } catch let err as NSError {
            performCallback() { callback?(.Fail(.IO(err))) }
        } catch let err as OmiseError {
            performCallback() { callback?(.Fail(err)) }
        }
        
        return nil
    }
    
    public func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
    
    func performCallback(callback: () -> ()) {
        config.callbackQueue.addOperationWithBlock(callback)
    }
}

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
    
    public func call<TOperation: Operation where TOperation.Result: OmiseObject>(operation: TOperation, callback: Request<TOperation>.Callback?) -> Request<TOperation>? {
        do {
            let req: Request<TOperation> = try Request(client: self, operation: operation, callback: callback)
            return req.start()
            
        } catch let err as NSError {
            performCallback() { callback?(.Fail(err: .IO(err: err))) }
        } catch let err as OmiseError {
            performCallback() { callback?(.Fail(err: err)) }
        }
        
        return nil
    }
    
    func performCallback(callback: () -> ()) {
        config.callbackQueue.addOperationWithBlock(callback)
    }
}

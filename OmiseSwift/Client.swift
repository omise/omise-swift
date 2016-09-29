import Foundation

open class Client: NSObject {
    open static let sessionIdentifier = "omise.co"
    
    let session: URLSession
    let operationQueue: OperationQueue
    
    open let config: Config
    
    public init(config: Config) {
        self.config = config
        
        self.operationQueue = OperationQueue()
        self.session = URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate: nil,
            delegateQueue: operationQueue)
        super.init()
    }
    
    open func call<TResult: OmiseObject>(_ operation: Operation<TResult>, callback: Operation<TResult>.Callback?) -> Request<TResult>? {
        do {
            let req: Request<TResult> = Request(client: self, operation: operation, callback: callback)
            return try req.start()
        } catch let err as OmiseError {
            performCallback() {
                callback?(.fail(err))
            }
        } catch let err as NSError {
            performCallback() {
                callback?(.fail(.io(err)))
            }
        }
        
        return nil
    }
    
    open func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
    
    func performCallback(_ callback: @escaping () -> ()) {
        config.callbackQueue.addOperation(callback)
    }
}

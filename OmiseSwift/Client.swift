import Foundation

public class Client: NSObject {
    public static let sessionIdentifier = "omise.co"
    
    private let session: NSURLSession
    private let operationQueue: NSOperationQueue
    
    public let config: Config
    
    public init(config: Config) throws {
        self.config = config
        
        self.operationQueue = NSOperationQueue()
        self.session = NSURLSession(
            configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration(),
            delegate: nil,
            delegateQueue: operationQueue)
        super.init()
    }
    
    public func call<TOperation: Operation where TOperation.Result: OmiseObject>(operation: TOperation, callback: Request<TOperation>.Callback) -> Request<TOperation>? {
//        guard let session = self.session else {
//            throw OmiseError.Unexpected(message: "failed to initialize NSURLSession.")
//        }
        
        do {
            let req: Request<TOperation> = try Request(config: config, session: session, operation: operation, callback: callback)
            return req.start()
            
        } catch let err as NSError {
            config.performCallback() { callback(nil, .IO(err: err)) }
        } catch let err as OmiseError {
            config.performCallback() { callback(nil, err) }
        }
        
        return nil
    }
}

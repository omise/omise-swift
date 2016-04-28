import Foundation

// TODO: Fold this into Client.perform(operation: Operation) -> Operation.result
public class Request<TOperation: Operation where TOperation.Result: OmiseObject>: NSObject {
    public typealias Callback = (TOperation.Result?, ErrorType?) -> ()
    
    private var dataTask: NSURLSessionTask? = nil
    private var callback: Callback? = nil
    
    public let config: Config
    public let operation: TOperation
    
    public let request: NSURLRequest
    public let session: NSURLSession
    
    public init?(config: Config, session: NSURLSession, operation: TOperation) {
        guard let request = Request.buildRequest(config, operation: operation) else {
            return nil
        }
        
        self.config = config
        self.operation = operation
        
        self.request = request
        self.session = session
        super.init()
        
        self.dataTask = session.dataTaskWithRequest(request, completionHandler: didComplete)
    }
    
    static func buildRequest(config: Config, operation: TOperation) -> NSURLRequest? {
        let request = NSMutableURLRequest(URL: operation.url)
    
        request.HTTPMethod = operation.method
        request.cachePolicy = .UseProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.HTTPBody = operation.payload
        
        let apiKey = operation.url.host?.containsString("vault.omise.co") ?? false ?
            config.publicKey :
            config.secretKey
        
        // TODO: Remove bang
        guard let auth = encodeApiKeyForAuthorization(apiKey!) else {
            return nil
        }
        
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func encodeApiKeyForAuthorization(apiKey: String) -> String? {
        guard let md5 = "\(apiKey):X"
            .dataUsingEncoding(NSUTF8StringEncoding)?
            .base64EncodedStringWithOptions(.Encoding64CharacterLineLength) else {
                return nil
        }
        
        return "Basic \(md5)"
    }
    
    func startWithCallback(callback: Request<TOperation>.Callback?) -> Request<TOperation> {
        self.callback = callback
        self.dataTask?.resume()
        return self
    }
    
    private func didComplete(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if callback == nil {
            return // no one's in the forest to hear the leaf falls
        }
        
        guard let httpResponse = response as? NSHTTPURLResponse else {
            return performCallback(nil, OmiseError.Unexpected(message: "no error and no response."))
        }
        
        switch httpResponse.statusCode {
        case 400..<600:
            guard let d = data else {
                return performCallback(nil, OmiseError.Unexpected(message: "error response with no data."))
            }
            
            guard let err: APIError = OmiseSerializer.deserialize(d) else {
                return performCallback(nil, OmiseError.Unexpected(message: "error response deserialization failure."))
            }
            
            return performCallback(nil, OmiseError.API(err: err))
            
        case 200..<300:
            guard let d = data else {
                return performCallback(nil, OmiseError.Unexpected(message: "HTTP 200 but no data"))
            }
            
            guard let result: TOperation.Result = OmiseSerializer.deserialize(d) else {
                return performCallback(nil, OmiseError.Unexpected(message: "JSON deserialization failure."))
            }
            
            NSLog("debug: \(result.attributes["id"])")
            return performCallback(result, nil)
            
        default:
            NSLog("unrecognized HTTP status code: \(httpResponse.statusCode)")
        }
    }
    
    private func performCallback(result: TOperation.Result?, _ error: ErrorType?) {
        guard let cb = callback else { return }
        config.callbackQueue.addOperationWithBlock { 
            cb(result, error)
        }
    }
}
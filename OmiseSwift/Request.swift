import Foundation

// TODO: Fold this into Client.perform(operation: Operation) -> Operation.result
public class Request<TResult: OmiseObject>: NSObject {
    typealias Callback = (TResult?, ErrorType?) -> ()
    
    private var dataTask: NSURLSessionTask? = nil
    private var callback: Callback? = nil
    
    public let config: Config
    public let operation: Operation<TResult>
    
    public let request: NSURLRequest
    public let session: NSURLSession
    
    public init?(config: Config, session: NSURLSession, operation: Operation<TResult>) {
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
    
    static func buildRequest(config: Config, operation: Operation<TResult>) -> NSURLRequest? {
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
        return "\(apiKey):X"
            .dataUsingEncoding(NSUTF8StringEncoding)?
            .base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
    }
    
    func startWithCallback(callback: Callback?) {
        self.callback = callback
        self.dataTask?.resume()
    }
    
    private func didComplete(data: NSData?, response: NSURLResponse?, error: NSError?) {
        if let e = error {
            callback?(nil, e)
            return
        }
        
        guard let httpResponse = response as? NSHTTPURLResponse else {
            callback?(nil, OmiseError.Unexpected(message: "no response."))
            return
        }
        
        switch httpResponse.statusCode {
        case 400..<600:
            var error =  OmiseError.Unexpected(message: "error response with no error data.")
            if let d = data, let err: APIError = OmiseSerializer.deserialize(d) {
                error = OmiseError.API(err: err)
            }
            
            callback?(nil, error)
            break
            
        case 200..<300:
            if let d = data {
                if let result: TResult = OmiseSerializer.deserialize(d) {
                    callback?(result, nil)
                } else {
                    callback?(nil, OmiseError.Unexpected(message: "JSON deserialization failure."))
                }
            } else {
                callback?(nil, OmiseError.Unexpected(message: "response 200 but no data"))
            }
            break
            
        default:
            break
        }
    }
}
import Foundation

public class Request<TOperation: Operation where TOperation.Result: OmiseObject>: NSObject {
    public typealias Callback = (TOperation.Result?, OmiseError?) -> ()
    
    private var dataTask: NSURLSessionTask? = nil
    private var callback: Callback? = nil
    
    public let config: Config
    public let operation: TOperation
    public let urlRequest: NSURLRequest
    public let session: NSURLSession
    
    public init(config: Config, session: NSURLSession, operation: TOperation, callback: Callback?) throws {
        self.callback = callback
        
        self.config = config
        self.operation = operation
        self.urlRequest = try Request.buildURLRequest(config, operation: operation)
        self.session = session
        super.init()
        
        self.dataTask = session.dataTaskWithRequest(urlRequest, completionHandler: didComplete)
    }
    
    static func buildURLRequest(config: Config, operation: TOperation) throws -> NSURLRequest {
        guard let host = operation.url.host else {
            throw OmiseError.Unexpected(message: "requested operation has invalid url.")
        }
        
        let apiKey = try selectApiKey(config, host: host)
        let auth = try encodeApiKeyForAuthorization(apiKey)
        
        let request = NSMutableURLRequest(URL: operation.url)
        request.HTTPMethod = operation.method
        request.cachePolicy = .UseProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.HTTPBody = operation.payload
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        return request
    }
    
    static func selectApiKey(config: Config, host: String) throws -> String {
        if host.containsString("vault.omise.co") {
            guard let key = config.publicKey else {
                throw OmiseError.Configuration(message: "vault operation requires public key.")
            }
            
            return key
            
        } else {
            guard let key = config.secretKey else {
                throw OmiseError.Configuration(message: "API operation requires secret key.")
            }
            
            return key
        }
    }
    
    static func encodeApiKeyForAuthorization(apiKey: String) throws -> String {
        guard let md5 = "\(apiKey):X"
            .dataUsingEncoding(NSUTF8StringEncoding)?
            .base64EncodedStringWithOptions(.Encoding64CharacterLineLength) else {
                throw OmiseError.Configuration(message: "bad API key (encoding failed.)")
        }
        
        return "Basic \(md5)"
    }
    
    
    func start() -> Request<TOperation> {
        dataTask?.resume()
        return self
    }
    
    private func didComplete(data: NSData?, response: NSURLResponse?, error: NSError?) {
        // no one's in the forest to hear the leaf falls.
        guard callback != nil else { return }
        
        if let err = error {
            return performCallback(nil, .IO(err: err))
        }
        
        guard let httpResponse = response as? NSHTTPURLResponse else {
            return performCallback(nil, .Unexpected(message: "no error and no response."))
        }
        
        guard let data = data else {
            return performCallback(nil, .Unexpected(message: "empty response."))
        }
        
        do {
            switch httpResponse.statusCode {
            case 400..<600:
                let err: APIError = try OmiseSerializer.deserialize(data)
                return performCallback(nil, .API(err: err))
                
            case 200..<300:
                let result: TOperation.Result = try OmiseSerializer.deserialize(data)
                return performCallback(result, nil)
                
            default:
                return performCallback(nil, .Unexpected(message: "unrecognized HTTP status code: \(httpResponse.statusCode)"))
            }
            
        } catch let err as NSError {
            return performCallback(nil, .IO(err: err))
        } catch let err as OmiseError {
            return performCallback(nil, err)
        }
    }
    
    private func performCallback(result: TOperation.Result?, _ error: OmiseError?) {
        guard let cb = callback else { return }
        config.performCallback { cb(result, error) }
    }
}
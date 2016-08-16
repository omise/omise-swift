import Foundation

public class Request<TResult: OmiseObject>: NSObject {
    public typealias Op = Operation<TResult>
    
    public let client: Client
    public let operation: Op
    public let callback: Op.Callback?
    
    public init(client: Client, operation: Op, callback: Op.Callback?) {
        self.client = client
        self.operation = operation
        self.callback = callback
        super.init()
    }
    
    static func buildURLRequest(config: Config, operation: Op) throws -> NSURLRequest {
        guard let host = operation.url.host else {
            throw OmiseError.Unexpected("requested operation has invalid url.")
        }
        
        let apiKey = try selectApiKey(config, host: host)
        let auth = try encodeApiKeyForAuthorization(apiKey)
        
        let request = NSMutableURLRequest(URL: operation.url)
        request.HTTPMethod = operation.method
        request.cachePolicy = .UseProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        
        guard !(request.HTTPMethod == "GET" && operation.payload != nil) else {
            omiseWarn("ignoring payloads for HTTP GET operation.")
            return request
        }
        
        request.HTTPBody = operation.payload
        return request
    }
    
    static func selectApiKey(config: Config, host: String) throws -> String {
        let key: String?
        if host.containsString("vault.omise.co") {
            key = config.publicKey
        } else {
            key = config.secretKey
        }
        
        guard let resolvedKey = key else {
            throw OmiseError.Configuration("no api key for host \(host).")
        }
        
        return resolvedKey
    }
    
    static func encodeApiKeyForAuthorization(apiKey: String) throws -> String {
        let data = "\(apiKey):X".dataUsingEncoding(NSUTF8StringEncoding)
        guard let md5 = data?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) else {
            throw OmiseError.Configuration("bad API key (encoding failed.)")
        }
        
        return "Basic \(md5)"
    }
    
    
    func start() throws -> Self {
        let urlRequest = try Request.buildURLRequest(client.config, operation: operation)
        let dataTask = client.session.dataTaskWithRequest(urlRequest, completionHandler: didComplete)
        dataTask.resume()
        return self
    }
    
    private func didComplete(data: NSData?, response: NSURLResponse?, error: NSError?) {
        // no one's in the forest to hear the leaf falls.
        guard callback != nil else { return }
        
        if let err = error {
            return performCallback(.Fail(.IO(err)))
        }
        
        guard let httpResponse = response as? NSHTTPURLResponse else {
            return performCallback(.Fail(.Unexpected("no error and no response.")))
        }
        
        guard let data = data else {
            return performCallback(.Fail(.Unexpected("empty response.")))
        }
        
        do {
            switch httpResponse.statusCode {
            case 400..<600:
                let err: APIError = try OmiseSerializer.deserialize(data)
                return performCallback(.Fail(.API(err)))
                
            case 200..<300:
                let result: TResult = try OmiseSerializer.deserialize(data)
                if let resource = result as? ResourceObject {
                    resource.attachedClient = client
                }
                
                return performCallback(.Success(result))
                
            default:
                return performCallback(.Fail(.Unexpected("unrecognized HTTP status code: \(httpResponse.statusCode)")))
            }
            
        } catch let err as NSError {
            return performCallback(.Fail(.IO(err)))
        } catch let err as OmiseError {
            return performCallback(.Fail(err))
        }
    }
    
    private func performCallback(result: Failable<TResult>) {
        guard let cb = callback else { return }
        client.performCallback { cb(result) }
    }
}
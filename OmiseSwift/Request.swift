import Foundation

// TODO: Fold this into Client.perform(operation: Operation) -> Operation.result
public class Request: NSObject {
    public let config: Config
    public let url: NSURL
    public let session: NSURLSession
    public let dataTask: NSURLSessionTask
    
    init?(config: Config, session: NSURLSession, method: String, url: NSURL, payload: NSData?) {
        guard let request = Request.buildRequest(config, method: method, url: url, payload: payload) else {
            return nil
        }
        
        self.config = config
        self.session = session
        self.url = url
        self.dataTask = session.dataTaskWithRequest(request)
        super.init()
    }
    
    static func buildRequest(config: Config, method: String, url: NSURL, payload: NSData?) -> NSURLRequest? {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.cachePolicy = .UseProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.HTTPBody = payload
        
        let apiKey = url.host?.containsString("vault.omise.co") ?? false ?
            config.publicKey :
            config.secretKey
        
        guard let auth = encodeApiKeyForAuthorization(apiKey) else {
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

    func start() {
        dataTask.resume()
    }
}
import Foundation



public class APIRequest<Result: OmiseObject> {
    public typealias Endpoint = APIEndpoint<Result>
    public typealias Callback = (Failable<Result>) -> Void
    
    let client: APIClient
    let endpoint: APIEndpoint<Result>
    let callback: APIRequest.Callback?
    
    var task: URLSessionDataTask?
    
    init(client: APIClient, endpoint: APIEndpoint<Result>, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }
    
    func start() throws -> Self {
        let urlRequest = try makeURLRequest()
        let dataTask = client.session.dataTask(with: urlRequest, completionHandler: didComplete)
        self.task = dataTask
        dataTask.resume()
        
        return self
    }
    
    fileprivate func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
        // no one's in the forest to hear the leaf falls.
        guard callback != nil else { return }
        
        
        if let err = error {
            return performCallback(.fail(.other(err)))
            
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return performCallback(.fail(.unexpected("no error and no response.")))
        }
        
        guard let data = data else {
            return performCallback(.fail(.unexpected("empty response.")))
        }
        
        let result: Failable<Result>
        do {
            switch httpResponse.statusCode {
            case 400..<600:
                let err: APIError = try deserializeData(data)
                result = .fail(.api(err))
                
            case 200..<300:
                result = .success(try endpoint.deserialize(data))

            default:
                result = .fail(.unexpected("unrecognized HTTP status code: \(httpResponse.statusCode)"))
            }
        } catch let err as OmiseError {
            result = .fail(err)

        } catch let err {
            result = .fail(.other(err))
        }
        
        performCallback(result)
    }
    
    fileprivate func performCallback(_ result: Failable<Result>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation({ cb(result) })
    }
    
    func makeURLRequest() throws -> URLRequest {
        let requestURL = endpoint.makeURL()
        
        let apiKey = client.preferredKeyForServerEndpoint(endpoint.endpoint)
        let auth = try APIRequest.encodeAuthorizationHeader(withAPIKey: apiKey)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = endpoint.method
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        
        let payload = endpoint.makePayload()
        guard !(request.httpMethod == "GET" && payload != nil) else {
            omiseWarn("ignoring payloads for HTTP GET operation.")
            return request as URLRequest
        }
        
        request.httpBody = payload
        return request as URLRequest
    }
    
    static func encodeAuthorizationHeader(withAPIKey apiKey: String) throws -> String {
        let data = "\(apiKey):X".data(using: String.Encoding.utf8)
        guard let md5 = data?.base64EncodedString(options: .lineLength64Characters) else {
            throw OmiseError.configuration("bad API key (encoding failed.)")
        }
        
        return "Basic \(md5)"
    }
    
}


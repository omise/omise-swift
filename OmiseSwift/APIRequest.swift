import Foundation


public class APIRequest<ResultType: OmiseObject> {
    public typealias Endpoint = APIEndpoint<ResultType>
    public typealias Callback = (APIResult<ResultType>) -> Void
    
    let client: APIClient
    let endpoint: APIEndpoint<ResultType>
    let callback: APIRequest.Callback?
    
    var task: URLSessionTask?
    
    init(client: APIClient, endpoint: APIEndpoint<ResultType>, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }
    
    public func cancel() {
        task?.cancel()
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
            performCallback(.failure(.other(err)))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            performCallback(.failure(.unexpected("no error and no response.")))
            return
        }
        
        guard let data = data else {
            performCallback(.failure(.unexpected("empty response.")))
            return
        }
        
        let result: APIResult<ResultType>
        do {
            switch httpResponse.statusCode {
            case 400..<600:
                let err: APIError = try deserializeData(data)
                result = .failure(.api(err))
                
            case 200..<300:
                result = .success(try endpoint.deserialize(data))
                
            default:
                result = .failure(.unexpected("unrecognized HTTP status code: \(httpResponse.statusCode)"))
            }
        } catch let err as OmiseError {
            result = .failure(err)
            
        } catch let err {
            result = .failure(.other(err))
        }
        
        performCallback(result)
    }
    
    fileprivate func performCallback(_ result: APIResult<ResultType>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation({ cb(result) })
    }
    
    func makeURLRequest() throws -> URLRequest {
        let requestURL = endpoint.makeURL()
        
        let auth = try client.preferredEncodedKeyForServerEndpoint(endpoint.endpoint)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = endpoint.parameter.method
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 10.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(client.config.apiVersion, forHTTPHeaderField: "Omise-Version")
        
        let payloadData: (String, Data)?
        
        switch endpoint.parameter {
        case .delete, .get, .head:
            payloadData = nil
        case .post(let query?):
            payloadData = makePayload(for: query)
        case .patch(let query?):
            payloadData = makePayload(for: query)
        default:
            payloadData = nil
        }
        
        guard !(request.httpMethod == "GET" && payloadData != nil) else {
            omiseWarn("ignoring payloads for HTTP GET operation.")
            return request as URLRequest
        }
        
        if let (header, payload) = payloadData {
            request.httpBody = payload
            request.addValue(header, forHTTPHeaderField: "Content-Type")
            request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
        }
        
        return request as URLRequest
    }
    
    private func makePayload(for query: APIQuery) -> (String, Data)? {
        switch query {
        case let query as APIURLQuery:
            return makePayload(for: query)
        case let query as APIFileQuery:
            return makePayload(for: query)
        default:
            return nil
        }
    }
    
    private func makePayload(for query: APIURLQuery) -> (String, Data)? {
        var urlComponents = URLComponents()
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        urlComponents.queryItems = try? encoder.encode(query)
        return urlComponents.percentEncodedQuery?.data(using: .utf8).map({ ("application/x-www-form-urlencoded", $0) })
    }
    
    private func makePayload(for query: APIFileQuery) -> (String, Data)? {
        let crlf = "\r\n"
        let boundary = "------\(UUID().uuidString)"
        
        var data = Data()
        data.append("--\(boundary)\(crlf)".data(using: .utf8, allowLossyConversion: false)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(query.filename)\"\(crlf + crlf)".data(using: .utf8, allowLossyConversion: false)!)
        data.append(query.fileContent)
        data.append("\(crlf)--\(boundary)--".data(using: .utf8, allowLossyConversion: false)!)
        
        return ("multipart/form-data; boundary=\(boundary)", data)
    }
}



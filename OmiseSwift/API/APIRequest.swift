import Foundation

public typealias ListAPIRequest<Result: OmiseObject> = APIRequest<ListParams, ListProperty<Result>>
public typealias RetrieveAPIRequest<Result: OmiseObject> = APIRequest<RetrieveParams, Result>

public class APIRequest<QueryType: APIQuery, ResultType: OmiseObject> {
    public typealias Endpoint = APIEndpoint<QueryType, ResultType>
    public typealias Callback = (APIResult<ResultType>) -> Void
    
    let client: APIClient
    let endpoint: APIEndpoint<QueryType, ResultType>
    let callback: APIRequest.Callback?
    
    var task: URLSessionTask?
    
    init(client: APIClient, endpoint: APIEndpoint<QueryType, ResultType>, callback: Callback?) {
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
    
    private func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
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
            
        } catch {
            result = .failure(.other(error))
        }
        
        performCallback(result)
    }
    
    private func performCallback(_ result: APIResult<ResultType>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation { cb(result) }
    }
    
    func makeURLRequest() throws -> URLRequest {
        let requestURL = endpoint.makeURL()
        
        let auth = try client.encodedPreferredKey(for: endpoint.endpoint)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = endpoint.method.rawValue
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 30.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(client.config.apiVersion, forHTTPHeaderField: "Omise-Version")
        
        let payloadData: (String, Data)?
        
        switch (endpoint.method, endpoint.query) {
        case (.delete, nil), (.get, nil), (.head, nil):
            payloadData = nil
        case (.post, let query?), (.patch, let query?):
            payloadData = query.makePayload()
        default:
            payloadData = nil
        }
        
        if let (header, payload) = payloadData {
            request.httpBody = payload
            request.addValue(header, forHTTPHeaderField: "Content-Type")
            request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
        }
        
        return request as URLRequest
    }
}

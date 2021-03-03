import Foundation


public class APIClient: NSObject {
    public static let sessionIdentifier = "omise.co"
    
    var session: URLSession!
    let operationQueue: OperationQueue
    
    public let config: APIConfiguration
    
    public init(config: APIConfiguration) {
        self.config = config
        
        self.operationQueue = OperationQueue()
        super.init()
        
        self.session = URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate: nil,
            delegateQueue: operationQueue)
    }
    
    func preferredKey(for endpoint: ServerEndpoint) -> String {
        switch endpoint {
        case .api:
            return config.accessKey.key
        case .vault(let publicKey):
            return publicKey.key
        }
    }
    
    func encodedPreferredKey(for endpoint: ServerEndpoint) throws -> String {
        let data = preferredKey(for: endpoint)
            .data(using: .utf8, allowLossyConversion: false)
        guard let encodedKey = data?.base64EncodedString() else {
            throw OmiseError.configuration("bad API key (encoding failed.)")
        }
        
        return "Basic \(encodedKey)"
    }
    
    @discardableResult
    public func request<QueryType, TResult>(
        to endpoint: APIEndpoint<QueryType, TResult>,
        callback: (APIRequest<QueryType, TResult>.Callback)?
        ) -> APIRequest<QueryType, TResult>? {
        do {
            let req = APIRequest<QueryType, TResult>(
                client: self, endpoint: endpoint, callback: callback)
            return try req.start()
        } catch let err as OmiseError {
            performCallback() {
                callback?(.failure(err))
            }
        } catch let err {
            performCallback() {
                callback?(.failure(.other(err)))
            }
        }
        
        return nil
    }
    
    
    func performCallback(_ callback: @escaping () -> Void) {
        operationQueue.addOperation(callback)
    }
    
    public func cancelAllOperations() {
        session.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }
}

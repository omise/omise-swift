import Foundation


public class APIClient: NSObject {
    public static let sessionIdentifier = "omise.co"
    
    var session: URLSession!
    let operationQueue: OperationQueue
    
    let config: APIConfiguration
    
    public init(config: APIConfiguration) {
        self.config = config
        
        self.operationQueue = OperationQueue()
        super.init()
        
        self.session = URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate: nil,
            delegateQueue: operationQueue)
    }
    
    func preferredKeyForServerEndpoint(_ endpoint: ServerEndpoint) -> String {
        switch endpoint {
        case .api:
            return config.accessKey.key
        case .vault(let publicKey):
            return publicKey.key
        }
    }
    
    func preferredEncodedKeyForServerEndpoint(_ endpoint: ServerEndpoint) throws -> String {
        let data = preferredKeyForServerEndpoint(endpoint).data(using: .utf8, allowLossyConversion: false)
        guard let encodedKey = data?.base64EncodedString() else {
            throw OmiseError.configuration("bad API key (encoding failed.)")
        }
        
        return "Basic \(encodedKey)"
    }
    
    @discardableResult
    public func requestToEndpoint<TResult>(_ endpoint: APIEndpoint<TResult>, callback: APIRequest<TResult>.Callback?) -> APIRequest<TResult>? {
        do {
            let req: APIRequest<TResult> = APIRequest(client: self, endpoint: endpoint, callback: callback)
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
    
    
    func performCallback(_ callback: @escaping () -> ()) {
        operationQueue.addOperation(callback)
    }
    
    public func cancelAllOperations() {
        session.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }
}


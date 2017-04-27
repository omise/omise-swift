import Foundation


public class APIClient: NSObject {
    public static let sessionIdentifier = "omise.co"
    
    var session: URLSession!
    let operationQueue: OperationQueue
    
    let config: APIConfiguration
    
    fileprivate let pinningSignature: Data? = {
        let bundle = Bundle(for: APIClient.self)
        if let certificateURL = bundle.url(forResource: "OmisePinning", withExtension: "der"),
            let certificateData = try? Data(contentsOf: certificateURL) {
            return certificateData
        } else {
            return nil
        }
    }()
    
    
    public init(config: APIConfiguration) {
        self.config = config
        
        self.operationQueue = OperationQueue()
        super.init()
        
        self.session = URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate: self,
            delegateQueue: operationQueue
        )
    }
    
    func preferredKeyForServerEndpoint(_ endpoint: ServerEndpoint) -> String {
        switch endpoint {
        case .api:
            return config.applicationKey.key
        case .vault(let publicKey):
            return publicKey.key
        }
    }
    
    func preferredEncodedKeyForServerEndpoint(_ endpoint: ServerEndpoint) throws -> String {
        // We append `:X` to the key as a workaround, as some parser would fail if they can't parse the password part.
        let data = (preferredKeyForServerEndpoint(endpoint) + ":X").data(using: .utf8, allowLossyConversion: false)
        
        guard let encodedKey = data?.base64EncodedString(options: .lineLength64Characters) else {
            throw OmiseError.configuration("bad API key (encoding failed.)")
        }
        
        return "Basic \(encodedKey)"
    }
    
    @discardableResult
    public func requestToEndpoint<TResult: OmiseObject>(_ endpoint: APIEndpoint<TResult>, callback: APIRequest<TResult>.Callback?) -> APIRequest<TResult>? {
        do {
            let req: APIRequest<TResult> = APIRequest(client: self, endpoint: endpoint, callback: callback)
            return try req.start()
        } catch let err as OmiseError {
            performCallback() {
                callback?(.fail(err))
            }
        } catch let err {
            performCallback() {
                callback?(.fail(.other(err)))
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


extension APIClient: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let credential: URLCredential?
        let challengeDisposition: URLSession.AuthChallengeDisposition
        defer {
            completionHandler(challengeDisposition, credential)
        }
        
        guard let signature = pinningSignature else {
            credential = nil
            challengeDisposition = .performDefaultHandling
            return
        }
        
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust = challenge.protectionSpace.serverTrust else {
                credential = nil
                challengeDisposition = .cancelAuthenticationChallenge
                return
        }
        var secresult = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust, &secresult)
        
        guard errSecSuccess == status,
            let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0)else {
                credential = nil
                challengeDisposition = .cancelAuthenticationChallenge
                return
        }
        
        let serverCertificateData = SecCertificateCopyData(serverCertificate)
        let data = CFDataGetBytePtr(serverCertificateData);
        let size = CFDataGetLength(serverCertificateData);
        let cert1 = NSData(bytes: data, length: size)
        if cert1.isEqual(to: signature) {
            credential = URLCredential(trust: serverTrust)
            challengeDisposition = .useCredential
        } else {
            credential = nil
            challengeDisposition = .cancelAuthenticationChallenge
        }
    }
}



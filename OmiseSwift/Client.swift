import Foundation

open class Client: NSObject {
    open static let sessionIdentifier = "omise.co"
    
    var session: URLSession!
    let operationQueue: OperationQueue
    
    open let config: Config
    
    fileprivate let pinningSignature: Data? = {
        let bundle = Bundle(for: Config.self)
        if let certificateURL = bundle.url(forResource: "cert", withExtension: "der"),
            let certificateData = try? Data(contentsOf: certificateURL) {
            return certificateData
        } else {
            return nil
        }
    }()
    
    public init(config: Config) {
        self.config = config
        
        self.operationQueue = OperationQueue()
        super.init()
        
        self.session = URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate: self,
            delegateQueue: operationQueue)
    }
    
    @discardableResult
    open func call<TResult: OmiseObject>(_ operation: Operation<TResult>, callback: Operation<TResult>.Callback?) -> Request<TResult>? {
        do {
            let req: Request<TResult> = Request(client: self, operation: operation, callback: callback)
            return try req.start()
        } catch let err as OmiseError {
            performCallback() {
                callback?(.fail(err))
            }
        } catch let err as NSError {
            performCallback() {
                callback?(.fail(.io(err)))
            }
        }
        
        return nil
    }
    
    open func cancelAllOperations() {
        operationQueue.cancelAllOperations()
    }
    
    func performCallback(_ callback: @escaping () -> ()) {
        config.callbackQueue.addOperation(callback)
    }
}


extension Client: URLSessionDelegate {
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



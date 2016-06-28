import Foundation

public class Config: NSObject {
    public let apiVersion: String?
    public let publicKey: String?
    public let secretKey: String?
    
    public let callbackQueue: NSOperationQueue
    
    public convenience init(secretKey: String) {
        self.init(publicKey: nil, secretKey: secretKey, apiVersion: nil, queue: nil)
    }
    
    public convenience init(publicKey: String, secretKey: String) {
        self.init(publicKey: publicKey, secretKey: secretKey, apiVersion: nil, queue: nil)
    }
    
    public init(publicKey: String?, secretKey: String?, apiVersion: String?, queue: NSOperationQueue?) {
        self.publicKey = publicKey
        self.secretKey = secretKey
        self.apiVersion = apiVersion
        self.callbackQueue = queue ?? NSOperationQueue.mainQueue()
    }
}

import Foundation

public class Config: NSObject {
    public let apiVersion: String?
    public let publicKey: String?
    public let secretKey: String?
    
    public convenience init(secretKey: String) {
        self.init(publicKey: nil, secretKey: secretKey, apiVersion: nil)
    }
    
    public convenience init(publicKey: String, secretKey: String) {
        self.init(publicKey: publicKey, secretKey: secretKey, apiVersion: nil)
    }
    
    public init(publicKey: String?, secretKey: String?, apiVersion: String?) {
        self.publicKey = publicKey
        self.secretKey = secretKey
        self.apiVersion = apiVersion
    }
}

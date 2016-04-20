import Foundation

public class Config {
    public let apiVersion: String?
    public let publicKey: String
    public let secretKey: String
    
    public convenience init(publicKey: String, secretKey: String) {
        self.init(publicKey: publicKey, secretKey: secretKey)
    }
    
    public init(publicKey: String, secretKey: String, apiVersion: String?) {
        self.publicKey = publicKey
        self.secretKey = secretKey
        self.apiVersion = apiVersion
    }
}

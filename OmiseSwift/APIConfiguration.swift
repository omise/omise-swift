import Foundation


public struct APIConfiguration {
    public let apiVersion: String = "2015-11-17"
    public let publicKey: String
    public let secretKey: String
    
    public init(publicKey: String, secretKey: String) {
        self.publicKey = publicKey
        self.secretKey = secretKey
    }
}


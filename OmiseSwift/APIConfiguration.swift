import Foundation


public struct APIConfiguration {
    let apiVersion: String
    let publicKey: String
    let secretKey: String
    
    public init(apiVersion: String, publicKey: String, secretKey: String) {
        self.apiVersion = apiVersion
        self.publicKey = publicKey
        self.secretKey = secretKey
    }
}


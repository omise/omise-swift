import Foundation

public class Config {
    let apiVersion: String?
    let publicKey: String
    let secretKey: String
    
    convenience init(publicKey: String, secretKey: String) {
        self.init(publicKey: publicKey, secretKey: secretKey)
    }
    
    init(publicKey: String, secretKey: String, apiVersion: String?) {
        self.publicKey = publicKey
        self.secretKey = secretKey
        self.apiVersion = apiVersion
    }
}

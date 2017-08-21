import Foundation


public struct PublicKey: OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatableObject, AccessKey {
    public let id: String
    public let object: String
    public let isLive: Bool
    public let createdDate: Date
    
    public let accessKey: String
    public let name: String?
    
    public let key: String
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseProperties = PublicKey.parseOmiseProperties(JSON: json),
            let key = json["key"] as? String,
            let kind = json["kind"] as? String,
            kind == "pkey", key.hasPrefix(kind) else {
                return nil
        }
        
        (self.object, self.isLive, self.id, self.createdDate) = omiseProperties
        self.accessKey = key
        self.name = json["name"] as? String
        
        self.key = self.accessKey + ":X"
    }
}

public struct AnyKey: AccessKey {
    public let key: String
    
    public init(_ key: String) {
        self.key = key
    }
}



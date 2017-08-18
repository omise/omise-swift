import Foundation

public protocol KeyKind {
    static var prefix: String { get }
    static var kind: String { get }
}

public enum ApplicationKey: KeyKind {
    public static let prefix: String = "akey"
    public static let kind: String = "application"
}

public enum PublicKey: KeyKind {
    public static let prefix: String = "pkey"
    public static let kind: String = "public"
}


public struct Key<Kind: KeyKind>: OmiseIdentifiableObject, OmiseLiveModeObject, OmiseCreatableObject {
    public let id: String
    public let object: String
    public let isLive: Bool
    public let createdDate: Date
    
    public let key: String
    public let name: String?
    
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseProperties = Key.parseOmiseProperties(JSON: json),
            let key = json["key"] as? String,
            let kind = json["kind"] as? String,
            Kind.kind == kind, key.hasPrefix(Kind.prefix) else {
                return nil
        }
        
        (self.object, self.isLive, self.id, self.createdDate) = omiseProperties
        self.key = key
        self.name = json["name"] as? String
    }
}

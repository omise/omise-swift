import Foundation

public struct Account: OmiseLocatableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/account")
    
    public let object: String
    public let location: String
    public let id: String
    
    public let email: String
}

extension Account {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseLocatoinProperties = Account.parseLocationResource(JSON: json),
            let id = json["id"] as? String,
            let email = json["email"] as? String else {
                return nil
        }
        (self.object, self.location) = omiseLocatoinProperties
        self.id = id
        self.email = email
    }
}

extension Account: SingletonRetrievable { }


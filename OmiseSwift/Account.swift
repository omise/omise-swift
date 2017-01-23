import Foundation

public struct Account: OmiseLocatableObject, OmiseIdentifiableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/account")
    
    public let object: String
    public let location: String
    public let id: String
    public let createdDate: Date
    
    public let email: String
}

extension Account {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseProperties = Account.parseOmiseProperties(JSON: json),
            let email = json["email"] as? String else {
                return nil
        }
        (self.object, self.location, self.id, self.createdDate) = omiseProperties
        self.email = email
    }
}

extension Account: SingletonRetrievable {}


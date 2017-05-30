import Foundation

public struct Account: OmiseLocatableObject, OmiseIdentifiableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/account")
    
    public let object: String
    public let location: String
    public let id: String
    public let createdDate: Date
    
    public let email: String
    
    public let currency: Currency
    public let supportedCurrencies: Set<Currency>
}

extension Account {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseProperties = Account.parseOmiseProperties(JSON: json),
            let email = json["email"] as? String,
            let currency = (json["currency"] as? String).flatMap(Currency.init(code:)),
            let supportedCurrencies = (json["supported_currencies"] as? [String]).flatMap({ $0.flatMap(Currency.init(code:)) }) else {
                return nil
        }
        (self.object, self.location, self.id, self.createdDate) = omiseProperties
        self.email = email
        self.currency = currency
        self.supportedCurrencies = Set(supportedCurrencies)
    }
}


extension Account: SingletonRetrievable {}


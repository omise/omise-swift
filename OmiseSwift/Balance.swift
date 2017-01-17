import Foundation


public struct Balance: OmiseLocatableObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/balance")
    
    public let object: String
    public let location: String
    public let isLive: Bool
    
    public var available: Value
    public var total: Value
}

extension Balance {
    public init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let omiseLocationObject = Balance.parseLocationResource(JSON: json),
            let isLive = json["livemode"] as? Bool,
            let available = json["available"] as? Int64,
            let total = json["total"] as? Int64,
            let currencyCode = json["currency"] as? String,
            let currency = Currency(code: currencyCode) else {
                return nil
        }
        
        (self.object, self.location) = omiseLocationObject
        self.isLive = isLive
        self.available = Value(currency: currency, amount: available)
        self.total = Value(currency: currency, amount: total)
    }
}

extension Balance: SingletonRetrievable { }



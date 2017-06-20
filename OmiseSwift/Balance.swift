import Foundation


public struct Balance: OmiseLocatableObject, OmiseLiveModeObject {
    public static let resourceInfo: ResourceInfo = ResourceInfo(path: "/balance")
    
    public let object: String
    public let location: String
    public let isLive: Bool
    
    public let currency: Currency
    public var available: Int64
    public var total: Int64
    
    public var availableValue: Value {
        return Value(amount: available, currency: currency)
    }
    
    public var totalValue: Value {
        return Value(amount: total, currency: currency)
    }
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
        self.available = available
        self.total = total
        self.currency = currency
    }
}

extension Balance: SingletonRetrievable {}



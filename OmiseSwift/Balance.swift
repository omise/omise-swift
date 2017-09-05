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
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case isLive = "livemode"
        case available
        case currency
        case total
    }
}


extension Balance: SingletonRetrievable {}



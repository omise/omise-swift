import Foundation

public struct Balance: OmiseLocatableObject, OmiseLiveModeObject, OmiseCreatedObject {
    public static let resourcePath = "/balance"
    
    public let object: String
    public let location: String
    public let isLiveMode: Bool
    public let createdDate: Date
    
    public let currency: Currency
    public var transferableAmount: Int64
    public var totalAmount: Int64
    public var reserveAmount: Int64
    
    public var transferableValue: Value {
        return Value(amount: transferableAmount, currency: currency)
    }
    
    public var totalValue: Value {
        return Value(amount: totalAmount, currency: currency)
    }
    
    public var reserveValue: Value {
        return Value(amount: reserveAmount, currency: currency)
    }
    
    private enum CodingKeys: String, CodingKey {
        case object
        case location
        case isLiveMode = "livemode"
        case createdDate = "created_at"
        case transferableAmount = "transferable"
        case currency
        case totalAmount = "total"
        case reserveAmount = "reserve"
    }
}

extension Balance: OmiseAPIPrimaryObject {}
extension Balance: SingletonRetrievable {}

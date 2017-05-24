import Foundation

public struct Value {
    public let currency: Currency
    public let amount: Int64
    
    public init(amount: Int64, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
    
    public var amountInUnit: Double {
        return currency.convert(fromSubunit: amount)
    }
}


extension Value {
    init?(JSON json: Any) {
        guard let json = json as? [String: Any], let amount = json["amount"] as? Int64,
            let currency = json["currency"].flatMap(CurrencyFieldConverter.convert(fromAttribute:)) else {
            return nil
        }
        
        self.amount = amount
        self.currency = currency
    }
}

extension Value: Equatable {
    public static func ==(lhs: Value, rhs: Value) -> Bool {
        return lhs.currency == rhs.currency && lhs.amount == rhs.amount
    }
}


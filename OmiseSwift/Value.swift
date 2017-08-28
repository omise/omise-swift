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


extension Value: Equatable {
    public static func ==(lhs: Value, rhs: Value) -> Bool {
        return lhs.currency == rhs.currency && lhs.amount == rhs.amount
    }
}


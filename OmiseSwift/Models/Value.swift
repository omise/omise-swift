import Foundation

public struct Value: Equatable {
    public let amount: Int64
    public let currency: Currency
    
    public init(amount: Int64, currency: Currency) {
        self.amount = amount
        self.currency = currency
    }
    
    public var amountInUnit: Double {
        return currency.convert(fromSubunit: amount)
    }
}

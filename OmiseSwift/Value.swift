import Foundation

public struct Value {
    public let currency: Currency
    public let amount: Int64
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


import Foundation

public class Refund: ResourceObject {
    public var amount: Int64? {
        get { return get("amount", Int64Converter.self) }
        set { set("amount", Int64Converter.self, toValue: newValue) }
    }
    
    public var currency: String? {
        get { return get("currency", StringConverter.self) }
        set { set("currency", StringConverter.self, toValue: newValue) }
    }
    
    public var charge: String? {
        get { return get("charge", StringConverter.self) }
        set { set("charge", StringConverter.self, toValue: newValue) }
    }
    
    public var transaction: String? {
        get { return get("transaction", StringConverter.self) }
        set { set("transaction", StringConverter.self, toValue: newValue) }
    }
}

/*package omise

// Refund represents Omise's refund object.
// See https://www.omise.co/refunds-api for more information.
type Refund struct {
    Base
    Amount      int64  `json:"amount" pretty:""`
    Currency    string `json:"currency" pretty:""`
    Charge      string `json:"charge" pretty:""`
    Transaction string `json:"transaction"`
}
*/

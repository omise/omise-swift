import Foundation

public class Refund: ResourceObject {
    public var amount: Int64?
    public var currency: String?
    public var charge: String?
    public var transaction: String?
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

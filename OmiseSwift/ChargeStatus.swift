import Foundation

public enum ChargeStatus {
    case failed(ChargeFailure)
    case reversed
    case pending
    case successful
}

extension ChargeStatus {
    init?(JSON json: Any) {
        guard let json = json as? [String: Any],
            let status = json["status"] as? String else {
                return nil
        }
        
        let failureCode = ChargeFailure(JSON: json)
        
        switch (status, failureCode) {
        case ("failed", let failureCode?):
            self = .failed(failureCode)
        case ("successful", nil):
            self = .successful
        case ("pending", nil):
            self = .pending
        case ("reversed", nil):
            self = .reversed
        default:
            return nil
        }
    }
}

/*
package omise

// ChargeStatus represents an enumeration of possible status of a Charge object, which
// can be one of the following list of constants:
type ChargeStatus string

const (
    ChargeFailed     ChargeStatus = "failed"
    ChargeReversed   ChargeStatus = "reversed"
    ChargePending    ChargeStatus = "pending"
    ChargeSuccessful ChargeStatus = "successful"
)
*/

import Foundation

public enum ChargeFailure {
    case insufficientFund
    case stolenOrLostCard
    case failedProcessing
    case paymentRejected
    case invalidSecurityCode
    case failedFraudCheck
    case invalidAccountNumber
    
    case other(String)
    
    var code: String {
        switch self {
        case .insufficientFund:
            return "insufficient_fund"
        case .stolenOrLostCard:
            return "stolen_or_lost_card"
        case .failedProcessing:
            return "failed_processing"
        case .paymentRejected:
            return "payment_rejected"
        case .invalidSecurityCode:
            return "invalid_security_code"
        case .failedFraudCheck:
            return "failed_fraud_check"
        case .invalidAccountNumber:
            return "invalid_account_number"
        case .other(let code):
            return code
        }
    }
}


extension ChargeFailure {
    init?(JSON json: Any) {
        guard let code = json as? String ?? (json as? [String: Any])?["failure_code"] as? String else {
            return nil
        }
        switch code {
        case "insufficient_fund":
            self = .insufficientFund
        case "stolen_or_lost_card":
            self = .stolenOrLostCard
        case "failed_processing":
            self = .failedProcessing
        case "payment_rejected":
            self = .paymentRejected
        case "invalid_security_code":
            self = .invalidSecurityCode
        case "failed_fraud_check":
            self = .failedFraudCheck
        case "invalid_account_number":
            self = .invalidAccountNumber
        case let code:
            self = .other(code)
        }
    }
}


/*
 insufficient_fund	Insufficient funds in the account or the card has reached the credit limit.
 stolen_or_lost_card	Card is stolen or lost.
 failed_processing	Card processing has failed, you may retry this transaction.
 payment_rejected	The payment was rejected by the issuer or the acquirer with no specific reason.
 invalid_security_code	The security code was invalid or the card didn't pass preauth.
 failed_fraud_check	Card was marked as fraudulent.
 invalid_account_number	This number is not attributed or has been deactivated.
 */


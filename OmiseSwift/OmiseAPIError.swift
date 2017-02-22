import Foundation

public enum ChargeFailure {
    /// Insufficient funds in the account or the card has reached the credit limit.
    case insufficientFund
    /// Card is stolen or lost.
    case stolenOrLostCard
    /// Card processing has failed, you may retry this transaction.
    case failedProcessing
    /// The payment was rejected by the issuer or the acquirer with no specific reason.
    case paymentRejected
    /// The security code was invalid or the card didn't pass preauth.
    case invalidSecurityCode
    /// Card was marked as fraudulent.
    case failedFraudCheck
    /// This number is not attributed or has been deactivated.
    case invalidAccountNumber
    
    case other(String)
    
    public var code: String {
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
    
    public init(code: String) {
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


extension ChargeFailure {
    init?(JSON json: Any) {
        guard let code = json as? String ?? (json as? [String: Any])?["failure_code"] as? String else {
            return nil
        }
        self = ChargeFailure.init(code: code)
    }
}


public enum TransferFailure {
    /// Bank rejected the transfer request
    case sentFailed
    /// Bank cannot process request for transferring to bank account
    case paidFailed
    
    public var code: String {
        switch self {
        case .sentFailed:
            return "transfer_send_failure"
        case .paidFailed:
            return "transfer_pay_failure"
        }
    }
    
    public init?(code: String) {
        switch code {
        case "transfer_send_failure":
            self = .sentFailed
        case "transfer_pay_failure":
            self = .paidFailed
        default:
            return nil
        }
    }
}


extension TransferFailure {
    init?(JSON json: Any) {
        guard let code = json as? String ?? (json as? [String: Any])?["failure_code"] as? String, let failure = TransferFailure.init(code: code) else {
            return nil
        }
        self = failure
    }
}



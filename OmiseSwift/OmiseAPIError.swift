import Foundation


public enum ChargeFailure: Decodable {
    
    // Credit Card Failure
    /// Insufficient funds in the account or the card has reached the credit limit.
    case insufficientFund
    /// Card is stolen or lost.
    case stolenOrLostCard
    /// The payment was rejected by the issuer or the acquirer with no specific reason.
    case paymentRejected
    /// The security code was invalid or the card didn't pass preauth.
    case invalidSecurityCode
    /// Card was marked as fraudulent.
    case failedFraudCheck
    /// This number is not attributed or has been deactivated.
    case invalidAccountNumber
    
    // Offsite Payment Failure
    case duplicateReferenceNumber
    case cannotConnectToIBanking
    case serviceCodeNotActivated
    case serviceCodeNotCertified
    case insufficientBalance
    case accountDoesNotExist
    case paymentCancelled
    case invalidReference
    case invalidParameters
    case timeout
    case internalError
    case amountMismatch
    case undefined
 
    /// Processing has failed.
    case failedProcessing
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
        case .duplicateReferenceNumber:
            return "duplicate_reference_number"
        case .cannotConnectToIBanking:
            return "cannot_connect_to_ibanking"
        case .serviceCodeNotActivated:
            return "service_code_not_activated"
        case .serviceCodeNotCertified:
            return "service_code_not_certified"
        case .insufficientBalance:
            return "insufficient_balance"
        case .accountDoesNotExist:
            return "account_does_not_exist"
        case .paymentCancelled:
            return "payment_cancelled"
        case .invalidReference:
            return "invalid_reference"
        case .invalidParameters:
            return "invalid_parameters"
        case .timeout:
            return "timeout"
        case .internalError:
            return "internal_error"
        case .amountMismatch:
            return "amount_mismatch"
        case .undefined:
            return "undefined"
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
        case "duplicate_reference_number":
            self = .duplicateReferenceNumber
        case "cannot_connect_to_ibanking":
            self = .cannotConnectToIBanking
        case "service_code_not_activated":
            self = .serviceCodeNotActivated
        case "service_code_not_certified":
            self = .serviceCodeNotCertified
        case "insufficient_balance":
            self = .insufficientBalance
        case "account_does_not_exist":
            self = .accountDoesNotExist
        case "payment_cancelled":
            self = .paymentCancelled
        case "invalid_reference":
            self = .invalidReference
        case "invalid_parameters":
            self = .invalidParameters
        case "timeout":
            self = .timeout
        case "internal_error":
            self = .internalError
        case "amount_mismatch":
            self = .amountMismatch
        case "undefined":
            self = .undefined
            
        case let code:
            self = .other(code)
        }
    }
    
    public init(from decoder: Decoder) throws {
        self.init(code: try decoder.singleValueContainer().decode(String.self))
    }
}


public enum TransferFailure: Decodable {
    /// Bank rejected the transfer request
    case sentFailed
    /// Bank cannot process request for transferring to bank account
    case paidFailed
    
    case other(String)
    
    public var code: String {
        switch self {
        case .sentFailed:
            return "transfer_send_failure"
        case .paidFailed:
            return "transfer_pay_failure"
        case .other(let code):
            return code
        }
    }
    
    public init(code: String) {
        switch code {
        case "transfer_send_failure":
            self = .sentFailed
        case "transfer_pay_failure":
            self = .paidFailed
        case let code:
            self = .other(code)
        }
    }
    
    public init(from decoder: Decoder) throws {
        self.init(code: try decoder.singleValueContainer().decode(String.self))
    }
}


